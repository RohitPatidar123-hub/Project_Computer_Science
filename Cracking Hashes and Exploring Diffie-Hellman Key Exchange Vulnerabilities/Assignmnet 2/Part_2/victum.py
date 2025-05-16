import socket
import random

def connect_to_server(ip, port, entry_number):
    try:
        # Connect to the MITM server instead of the Oracle server
        client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client.connect((ip, port))
        print(f"Connected to Oracle server at {ip}:{port}")

        client.sendall(entry_number.encode())
        response = client.recv(1024).decode()
        print("Received response:", response)
        
        stringP, stringG = response.split(",")
        P = int(stringP)
        G = int(stringG)
        print(f"P is {P}, and G is {G}")

        b = random.randint(1, P - 1)
        B = pow(G, b, P)  # Client's public key
        print(f"Client's private key (b): {b}")
        print(f"Client's public key (B): {B}")

        client.sendall(str(B).encode())
        print("Sent public key B to the server.")

        A_response = client.recv(1024).decode()
        A = int(A_response)
        print(f"Server's public key (A): {A}")

        shared_secret = pow(A, b, P)  # Calculate the shared secret using A
        print(f"The shared secret is: {shared_secret}")

        print("Started guessing server's private key...")
        for i in range(1, P):
            guess = i
            if pow(G, guess, P) == A:
                print("The private key of server is ", i)
                break
        else:
            print("Failed to deduce the server's private key.")

    except socket.error as e:
        print(f"Socket error: {e}")
    finally:
        client.close()
        print("Connection closed.")

def main():
    mitm_ip = "127.0.0.1"  # MITM server IP
    mitm_port = 6666        # MITM server port
    entry_number = "2024MCS2450"

    connect_to_server(mitm_ip, mitm_port, entry_number)

if __name__ == "__main__":
    main()



