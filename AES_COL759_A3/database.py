# database.py
import sqlite3
from datetime import datetime


def setup_database():
    conn = sqlite3.connect("messages.db")
    cursor = conn.cursor()
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS messages (
            id INTEGER PRIMARY KEY,
            user_id BLOB,      -- Encrypted username
            message BLOB,      -- Encrypted message content
            iv BLOB,           -- Initialization Vector
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    """
    )
    conn.commit()
    conn.close()


def store_message(user_id: bytes, message: bytes, iv: bytes):
    conn = sqlite3.connect("messages.db")
    cursor = conn.cursor()
    cursor.execute(
        """
        INSERT INTO messages (user_id, message, iv, timestamp)
        VALUES (?, ?, ?, ?)
    """,
        (
            sqlite3.Binary(user_id),
            sqlite3.Binary(message),
            sqlite3.Binary(iv),
            datetime.now(),
        ),
    )
    conn.commit()
    conn.close()


# Initialize the database
if __name__ == "__main__":
    setup_database()
    print("Database setup complete.")
