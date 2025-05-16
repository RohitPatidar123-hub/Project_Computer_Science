
import socket
import threading
import random

S=True

# Configuration for Oracle Server
ORACLE_IP = "10.237.27.193"  # Oracle server IP (localhost for testing)
ORACLE_PORT = 5555        # Oracle server port

# Configuration for MITM Server
MITM_IP = "127.0.0.1"    # MITM server listens on localhost
MITM_PORT = 6666          # MITM server port


def handle_victim(victim_socket, oracle_ip, oracle_port):
    """
    Handles communication between the victim and the Oracle server, performing MITM attack.
    """
    try:
        # Step 1: Connect to the Oracle Server
        oracle_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        oracle_socket.connect((oracle_ip, oracle_port))
        print(f"[MITM] Connected to Oracle Server at {oracle_ip}:{oracle_port}")

        # Step 2: Receive entry number from victim and forward to server
        entry_number = victim_socket.recv(1024).decode().strip()
        print(f"[MITM] Received entry number from victim: {entry_number}")
        oracle_socket.sendall(entry_number.encode())
        print(f"[MITM] Forwarded entry number to Oracle: {entry_number}")

        # Step 3: Receive P and G from server and forward to victim
        oracle_response = oracle_socket.recv(1024).decode().strip()
        print(f"[MITM] Received (P, G) from Oracle: {oracle_response}")
        victim_socket.sendall(oracle_response.encode())
        print(f"[MITM] Forwarded (P, G) to victim.")

        # Parse P and G
        try:
            stringP, stringG = oracle_response.split(",")
            P = int(stringP)
            G = int(stringG)
            print(f"[MITM] Parsed P: {P}, G: {G}")
        except ValueError:
            print("[MITM] Failed to parse P and G from Oracle response.")
            return

        # Step 4: Receive B from victim
        victim_public_key = victim_socket.recv(1024).decode().strip()
        try:
            B_victim = int(victim_public_key)
            print(f"[MITM] Received victim's public key (B): {B_victim}")
        except ValueError:
            print("[MITM] Failed to parse victim's public key (B).")
            return

        # Step 5: Choose c, compute C = G^c mod P
        c = random.randint(2, 5000)  # MITM's private key
        C = pow(G, c, P)
        print(f"[MITM] Chose own private key (c): {c}")
        print(f"[MITM] Computed public key (C): {C}")

        # Step 6: Send C to Oracle as victim's public key
        oracle_socket.sendall(str(C).encode())
        print(f"[MITM] Sent C to Oracle as victim's public key.")

        # Step 7: Send C to victim as Oracle's public key
        victim_socket.sendall(str(C).encode())
        print(f"[MITM] Sent C to victim as Oracle's public key.")

        # Step 8: Receive A from Oracle (server's public key based on C)
        A_server = oracle_socket.recv(1024).decode().strip()
        try:
            A_server = int(A_server)
            print(f"[MITM] Received server's public key (A): {A_server}")
        except ValueError:
            print("[MITM] Failed to parse server's public key (A).")
            return

        # Step 9: Send A to victim as Oracle's public key
        victim_socket.sendall(str(A_server).encode())
        print(f"[MITM] Sent A to victim as Oracle's public key.")

        # Step 10: Compute shared secrets
        # Shared secret with Oracle server: S_server = A_server^c mod P
        S_server = pow(A_server, c, P)
        print(f"[MITM] Computed shared secret with Oracle (S_server): {S_server}")

        # Shared secret with victim: S_victim = B_victim^c mod P
        S_victim = pow(B_victim, c, P)
        print(f"[MITM] Computed shared secret with victim (S_victim): {S_victim}")
        S=False
    
        
                        


    except socket.error as e:
        print(f"[MITM] Socket error: {e}")
    except Exception as ex:
        print(f"[MITM] Exception occurred: {ex}")
    finally:
        victim_socket.close()
        print("[MITM] Closed connection with victim.")
        try:
            oracle_socket.close()
            print("[MITM] Closed connection with Oracle.")
        except:
            pass
        print("[MITM] Connection handling complete.")
       

def start_mitm_server(mitm_ip, mitm_port, oracle_ip, oracle_port):
    """
    Starts the MITM server to listen for victim connections.
    """
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        server.bind((mitm_ip, mitm_port))
        server.listen(5)
        print(f"[MITM] Listening on {mitm_ip}:{mitm_port}...")
    except socket.error as e:
        print(f"[MITM] Failed to bind or listen on {mitm_ip}:{mitm_port}: {e}")
        return
    S=True
    while S:
        try:
            victim_socket, victim_addr = server.accept()
            print(f"[MITM] Accepted connection from {victim_addr}")
            victim_handler = threading.Thread(target=handle_victim, args=(victim_socket, oracle_ip, oracle_port))
            victim_handler.start()
        except KeyboardInterrupt:
            print("\n[MITM] Shutting down server.")
            break
        except socket.error as e:
            print(f"[MITM] Socket error during accept: {e}")
        except Exception as ex:
            print(f"[MITM] Exception during accept: {ex}")

    server.close()

if __name__ == "__main__":
    start_mitm_server(MITM_IP, MITM_PORT, ORACLE_IP, ORACLE_PORT)
