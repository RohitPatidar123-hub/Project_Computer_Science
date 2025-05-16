# decrypt_messages.py
import sqlite3

from aes import decrypt_cbc
from utils import derive_key

# Constants
PASSWORD = "YourSecurePassword"  # Must match the server's password
SALT = b"\x1a\xb4\x10\x8c\xe2\xa1\x95\x1f\xbf\xc3\xd9\x88\x7f\xea\xfd\xe4"  # Must match the server's salt
DATABASE = "messages.db"


def decrypt_messages():
    # Derive the encryption key
    key = derive_key(PASSWORD, SALT)

    # Connect to the SQLite database
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()

    # Retrieve all messages
    cursor.execute("SELECT id, user_id, message, iv, timestamp FROM messages")
    rows = cursor.fetchall()

    if not rows:
        print("No messages found in the database.")
        conn.close()
        return

    print(f"{'ID':<5} {'User':<20} {'Message':<50} {'Timestamp'}")
    print("-" * 100)

    for row in rows:
        id, encrypted_user_id, encrypted_message, iv, timestamp = row

        try:
            # Decrypt user_id
            decrypted_user_id = decrypt_cbc(key, iv, encrypted_user_id).decode("utf-8")

            # Decrypt message
            decrypted_message = decrypt_cbc(key, iv, encrypted_message).decode("utf-8")

            print(
                f"{id:<5} {decrypted_user_id:<20} {decrypted_message:<50} {timestamp}"
            )

        except UnicodeDecodeError as ude:
            print(f"Error decrypting message ID {id}: {ude}")
        except Exception as e:
            print(f"Error decrypting message ID {id}: {e}")

    # Close the database connection
    conn.close()


if __name__ == "__main__":
    decrypt_messages()
