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
from datetime import datetime

# Define paths
USER = getpass.getuser()
OUTPUTPATH = "E:\\Browser_Backup"  # Change to your USB drive letter
BROWSERS = {
    "Chrome": os.path.join(os.getenv("LOCALAPPDATA"), "Google\\Chrome\\User Data\\Default"),
    "Edge": os.path.join(os.getenv("LOCALAPPDATA"), "Microsoft\\Edge\\User Data\\Default"),
    "Brave": os.path.join(os.getenv("LOCALAPPDATA"), "BraveSoftware\\Brave-Browser\\User Data\\Default"),
    "Firefox": os.path.join(os.getenv("APPDATA"), "Mozilla\\Firefox\\Profiles"),
}

# Ensure USB path exists
if not os.path.exists(OUTPUTPATH):
    os.makedirs(OUTPUTPATH)

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
    backup_db = os.path.join(OUTPUTPATH, f"{browser}_Passwords.db")
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
    with open(os.path.join(OUTPUTPATH, f"{browser}_Passwords.json"), "w") as f:
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
            shutil.copy(logins_file, os.path.join(OUTPUTPATH, "Firefox_Passwords.json"))
            print("Firefox passwords saved.")

def backup_chrome_history(browser, path):
    """Backup browsing history from Chrome-based browsers."""
    history_path = os.path.join(path, "History")
    if not os.path.exists(history_path):
        return
    
    # Create a copy of the history file to avoid database lock
    backup_db = os.path.join(OUTPUTPATH, f"{browser}_History.db")
    shutil.copy(history_path, backup_db)
    
    conn = sqlite3.connect(backup_db)
    cursor = conn.cursor()
    
    # Query to get history with titles and visit counts
    cursor.execute("""
        SELECT url, title, visit_count, last_visit_time 
        FROM urls 
        ORDER BY last_visit_time DESC
    """)
    
    history = []
    for row in cursor.fetchall():
        url, title, visit_count, last_visit_time = row
        # Convert Chrome timestamp to readable date
        # Chrome timestamp is microseconds since Jan 1, 1601
        chrome_time = datetime(1601, 1, 1) + datetime.timedelta(microseconds=last_visit_time)
        
        history.append({
            "url": url,
            "title": title,
            "visit_count": visit_count,
            "last_visit": chrome_time.strftime("%Y-%m-%d %H:%M:%S")
        })
    
    conn.close()
    
    # Save history to JSON file
    with open(os.path.join(OUTPUTPATH, f"{browser}_History.json"), "w", encoding="utf-8") as f:
        json.dump(history, f, indent=4, ensure_ascii=False)
    print(f"{browser} history saved.")

def backup_firefox_history():
    """Backup browsing history from Firefox."""
    profiles_path = BROWSERS["Firefox"]
    if not os.path.exists(profiles_path):
        return
        
    for profile in os.listdir(profiles_path):
        profile_path = os.path.join(profiles_path, profile)
        places_file = os.path.join(profile_path, "places.sqlite")
        
        if os.path.exists(places_file):
            # Create a copy of the places database
            backup_db = os.path.join(OUTPUTPATH, "Firefox_History.db")
            shutil.copy(places_file, backup_db)
            
            conn = sqlite3.connect(backup_db)
            cursor = conn.cursor()
            
            # Query to get history with titles and visit counts
            cursor.execute("""
                SELECT url, title, visit_count, last_visit_date 
                FROM moz_places 
                WHERE visit_count > 0 
                ORDER BY last_visit_date DESC
            """)
            
            history = []
            for row in cursor.fetchall():
                url, title, visit_count, last_visit_date = row
                # Convert Firefox timestamp to readable date
                # Firefox timestamp is microseconds since Jan 1, 1970
                if last_visit_date:
                    firefox_time = datetime.fromtimestamp(last_visit_date / 1000000)
                    last_visit = firefox_time.strftime("%Y-%m-%d %H:%M:%S")
                else:
                    last_visit = "Unknown"
                
                history.append({
                    "url": url,
                    "title": title,
                    "visit_count": visit_count,
                    "last_visit": last_visit
                })
            
            conn.close()
            
            # Save history to JSON file
            with open(os.path.join(OUTPUTPATH, "Firefox_History.json"), "w", encoding="utf-8") as f:
                json.dump(history, f, indent=4, ensure_ascii=False)
            print("Firefox history saved.")
            break  # Only process the first profile found

# Backup bookmarks, passwords, and history
for browser, path in BROWSERS.items():
    if os.path.exists(path):
        print(f"Backing up {browser} data...")
        copy_file(os.path.join(path, "Bookmarks"), OUTPUTPATH, f"{browser}_Bookmarks.json")
        
        if browser != "Firefox":
            backup_chrome_passwords(browser, path)
            backup_chrome_history(browser, path)
        else:
            backup_firefox_passwords()
            backup_firefox_history()

print("Backup completed.")
