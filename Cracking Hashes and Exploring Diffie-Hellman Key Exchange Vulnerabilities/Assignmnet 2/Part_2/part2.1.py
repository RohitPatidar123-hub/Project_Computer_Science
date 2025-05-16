import socket
import random

def connect_to_server(ip, port, entry_number):
    try:
        # Create a single socket connection
        client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client.connect((ip, port))
        print(f"Connected to server at {ip}:{port}")

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

        print("Started guessing server's private key ")
        for i in range(1,P-1):
            guess = i
            if(pow(G,guess,P) == A):
                print("The private key of server is ", i)
                break


        # Optionally, continue communication here if needed

    except socket.error as e:
        print(f"Socket error: {e}")
    finally:
        client.close()
        print("Connection closed.")

def main():
    ip = "10.208.66.147"
    port = 5555
    entry_number = "2024MCS2450"

    connect_to_server(ip, port, entry_number)

if __name__ == "__main__":
    main()
