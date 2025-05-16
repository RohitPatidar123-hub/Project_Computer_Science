
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad


def encrypt_cbc(key: bytes, iv: bytes, plaintext: bytes) -> bytes:

    cipher = AES.new(key, AES.MODE_CBC, iv)
    padded_plaintext = pad(plaintext, AES.block_size)
    ciphertext = cipher.encrypt(padded_plaintext)
    return ciphertext


def decrypt_cbc(key: bytes, iv: bytes, ciphertext: bytes) -> bytes:

    cipher = AES.new(key, AES.MODE_CBC, iv)
    padded_plaintext = cipher.decrypt(ciphertext)
    plaintext = unpad(padded_plaintext, AES.block_size)
    return plaintext
