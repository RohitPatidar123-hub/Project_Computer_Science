# client.py
import os
import socket
import sys

from aes import encrypt_cbc  
from utils import derive_key

# Constants
SERVER_HOST = "127.0.0.1"  
SERVER_PORT = 65432
BUFFER_SIZE = 4096
PASSWORD = "YourSecurePassword"  
SALT = b"\x1a\xb4\x10\x8c\xe2\xa1\x95\x1f\xbf\xc3\xd9\x88\x7f\xea\xfd\xe4" 
MAX_USERNAME_LENGTH = 16  


KEY = derive_key(PASSWORD, SALT)


def send_message(client_socket, user_id, message):
  
    iv = os.urandom(16)

    
    user_id_bytes = user_id.encode("utf-8")
    if len(user_id_bytes) > MAX_USERNAME_LENGTH:
        user_id_bytes = user_id_bytes[:MAX_USERNAME_LENGTH]
        user_id = user_id_bytes.decode("utf-8", errors="ignore")
        print(f"Username truncated to: {user_id}")

 
    encrypted_user_id = encrypt_cbc(KEY, iv, user_id.encode("utf-8"))
    encrypted_message = encrypt_cbc(KEY, iv, message.encode("utf-8"))

   
    user_id_length = len(encrypted_user_id)
    data = (
        user_id_length.to_bytes(4, byteorder="big")
        + iv
        + encrypted_user_id
        + encrypted_message
    )


    data_length = len(data)
    client_socket.sendall(data_length.to_bytes(4, byteorder="big"))
   
    client_socket.sendall(data)


def main():
    if len(sys.argv) != 2:
        print(f"Usage: python {sys.argv[0]} <username>")
        sys.exit(1)

    username = sys.argv[1]

   
    username_bytes = username.encode("utf-8")
    if len(username_bytes) > MAX_USERNAME_LENGTH:
        print(f"Username exceeds maximum length of {MAX_USERNAME_LENGTH} bytes.")
        username_bytes = username_bytes[:MAX_USERNAME_LENGTH]
        username = username_bytes.decode("utf-8", errors="ignore")
        print(f"Username truncated to: {username}")

    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        client.connect((SERVER_HOST, SERVER_PORT))
        print(f"[*] Connected to {SERVER_HOST}:{SERVER_PORT} as {username}")

        while True:
            message = input("Enter message (type 'exit' to quit): ")
            if message.lower() == "exit":
                break
            send_message(client, username, message)
    except BrokenPipeError:
        print("[-] Connection error: Broken pipe.")
    except Exception as e:
        print(f"[-] Connection error: {e}")
    finally:
        client.close()
        print("[*] Disconnected from the server.")


if __name__ == "__main__":
    main()
