
import hashlib


PASSWORD = "YourSecurePassword"  
SALT = b"\x1a\xb4\x10\x8c\xe2\xa1\x95\x1f\xbf\xc3\xd9\x88\x7f\xea\xfd\xe4"  
ITERATIONS = 100000
KEY_LENGTH = 32  


def derive_key(
    password: str, salt: bytes, iterations: int = ITERATIONS, dklen: int = KEY_LENGTH
) -> bytes:

    key = hashlib.pbkdf2_hmac("sha256", password.encode(), salt, iterations, dklen)
    return key
