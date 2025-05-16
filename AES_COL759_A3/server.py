# server.py
import socket
import threading

from aes import decrypt_cbc  
from database import setup_database, store_message
from utils import derive_key

# Constants
SERVER_HOST = "0.0.0.0"  
SERVER_PORT = 65432  
BUFFER_SIZE = 4096
PASSWORD = "YourSecurePassword"  
SALT = b"\x1a\xb4\x10\x8c\xe2\xa1\x95\x1f\xbf\xc3\xd9\x88\x7f\xea\xfd\xe4"  
MAX_USERNAME_LENGTH = 16  


KEY = derive_key(PASSWORD, SALT)


def handle_client(client_socket, address):
    print(f"[+] New connection from {address}")
    try:
        while True:
           
            data_length_bytes = client_socket.recv(4)
            if not data_length_bytes:
                break
            data_length = int.from_bytes(data_length_bytes, byteorder="big")

            
            data = b""
            while len(data) < data_length:
                packet = client_socket.recv(BUFFER_SIZE)
                if not packet:
                    break
                data += packet
            if len(data) != data_length:
                print(f"[-] Incomplete data received from {address}")
                break

         
            user_id_length = int.from_bytes(data[:4], byteorder="big")
            iv = data[4 : 4 + 16]
            encrypted_user_id = data[4 + 16 : 4 + 16 + user_id_length]
            encrypted_message = data[4 + 16 + user_id_length :]

            try:
              
                decrypted_user_id = decrypt_cbc(KEY, iv, encrypted_user_id).decode(
                    "utf-8"
                )
                decrypted_message = decrypt_cbc(KEY, iv, encrypted_message).decode(
                    "utf-8"
                )

               
                if len(decrypted_user_id.encode("utf-8")) > MAX_USERNAME_LENGTH:
                    print(
                        f"[-] Username exceeds maximum length from {address}. Truncating."
                    )
                    decrypted_user_id = decrypted_user_id[:MAX_USERNAME_LENGTH]

                print(f"[{decrypted_user_id}] {decrypted_message}")

               
                store_message(encrypted_user_id, encrypted_message, iv)
            except UnicodeDecodeError as ude:
                print(f"[-] Decoding error for message from {address}: {ude}")
            except Exception as e:
                print(f"[-] Error processing message from {address}: {e}")
    except Exception as e:
        print(f"[-] Error handling client {address}: {e}")
    finally:
        client_socket.close()
        print(f"[-] Connection closed from {address}")


def start_server():
    setup_database()
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((SERVER_HOST, SERVER_PORT))
    server.listen(5)
    print(f"[*] Server listening on {SERVER_HOST}:{SERVER_PORT}")

    try:
        while True:
            client_socket, addr = server.accept()
            client_handler = threading.Thread(
                target=handle_client, args=(client_socket, addr)
            )
            client_handler.start()
    except KeyboardInterrupt:
        print("\n[*] Shutting down the server.")
    finally:
        server.close()


if __name__ == "__main__":
    start_server()
