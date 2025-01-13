import pyautogui
import pyperclip
from pynput.mouse import Listener, Button
import os 
def on_click(x,y,button,pressed):
    if button == Button.left:
        if pressed:
            position = pyautogui.position
            r,g,b=pyautogui.pixel(x,y)
            color = f"#{r:02x}{g:02x}{b:02x}"
            pyperclip.copy(str(color))
            os.system(f"notify-send 'color: {color}'")
            return False
with Listener(on_click=on_click) as listener:
    listener.join()
