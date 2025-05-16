#!/usr/bin/python3
import socket
import ssl
import sys
import pprint
import subprocess
import os
import shutil # for removing existing certs ... then we will recreate again 


def task_1(hostname):
    port = 443
    cadir = '/etc/ssl/certs'

    # TLS context setup
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
    context.load_verify_locations(capath=cadir)
    context.verify_mode = ssl.CERT_REQUIRED
    context.check_hostname = True

    # TCP connection
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((hostname, port))
    input("\033[32mTCP connection established. Press Enter to start TLS handshake...\033[0m")

    # TLS wrapping
    ssock = context.wrap_socket(sock, server_hostname=hostname, do_handshake_on_connect=False)
    ssock.do_handshake()

    # Print server certificate and cipher
    print("\033[33m=== Cipher Used ===\033[0m")  
    print(ssock.cipher())

    print("\n\033[33m=== Server Certificate ===\033[0m")
    pprint.pprint(ssock.getpeercert())

    input("\033[31mTLS handshake complete. Press Enter to close connection...\033[0m")

    # Close connection
    ssock.shutdown(socket.SHUT_RDWR)
    ssock.close()

def task_2(hostname):
    
        port = 443
        # Use a local folder for CA certificates. 
        # Populate this folder with individual certificate files (e.g., by copying from /etc/ssl/certs)
        # Remove the entire './certs' directory if it exists, then recreate it.
        if os.path.exists('./certs'):
                    shutil.rmtree('./certs')  
        os.makedirs('./certs')
        # Ensure the target directory exists
        # if not os.path.exists('./certs'):
        #     os.makedirs('./certs')
        # # Copy all CA certificate files from /etc/ssl/certs to ./certs
        # subprocess.run("cp /etc/ssl/certs/* ./certs/", shell=True, check=True) 
        print("\033[33m==========================================================Run the client pro-gram. Since the folder (./certs) is empty, the program will throw an error======================================================\033[0m")   
        if os.path.exists('./certs'):
                    shutil.rmtree('./certs')  
        os.makedirs('./certs')
        print("Removing the entire './certs' directory from current directory if it exists, then recreate it.")
        cadir = './certs'
        # Set up the TLS context
        context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
        context.load_verify_locations(capath=cadir)
        context.verify_mode = ssl.CERT_REQUIRED
        context.check_hostname = True

        # Create TCP connection
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect((hostname, port))
        input("\033[32mTCP connection established.\033[0m Press Enter to start TLS handshake...")

        try :
                # Wrap the socket with TLS and perform the handshake
                ssock = context.wrap_socket(sock, server_hostname=hostname, do_handshake_on_connect=False)
                ssock.do_handshake()
                # Print the cipher suite and server certificate
                print("=== Cipher Used ===")
                print(ssock.cipher())
                print("\n=== Server Certificate ===")
                pprint.pprint(ssock.getpeercert())

                input("\033[34mTLS handshake complete\033[0mPress Enter to close connection...")

                # Close the TLS connection
                ssock.shutdown(socket.SHUT_RDWR)
                ssock.close()

        except ssl.SSLError as e:
                print("\033[31mError during TLS handshake:\033[0m", e)
                print("Explanation : This error occurs because, with an empty folder, no trusted certificates are found. Without any CA certificates, the client cannot verify the authenticity of the server’s certificate, and the handshake cannot be completed.")
                sock.close()
                print("================================================There are two common ways to populate your local certs folder with valid CA certificates==================================\n\n\n")
                print("\033[33m>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  Option A: Copying from the System CA Directory  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\033[0m")
                if not os.path.exists('./certs'):
                           os.makedirs('./certs')

                # Copy all CA certificate files from /etc/ssl/certs to ./certs
                print("Copying  certificates from /etc/ssl/certs to My local folder ./certs")
                subprocess.run("cp /etc/ssl/certs/* ./certs/", shell=True, check=True) 
                print("Process Complete") 
                print("Note: This might copy many files and you may not need all of them. Some systems have a combined CA bundle (like ca-certificates.crt), but many applications expect individual certificate files.")
                # Set up the TLS context
                context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
                context.load_verify_locations(capath=cadir)
                context.verify_mode = ssl.CERT_REQUIRED
                context.check_hostname = True
                # Create TCP connection
                sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                sock.connect((hostname, port))
                input("\033[32mTCP connection established.\033[0m Press Enter to start TLS handshake...")
                                # Wrap the socket with TLS and perform the handshake
                ssock = context.wrap_socket(sock, server_hostname=hostname, do_handshake_on_connect=False)
                ssock.do_handshake()
                # Print the cipher suite and server certificate
                print("========================== Cipher Used ========================")
                print(ssock.cipher())
                print("\n=== Server Certificate ===")
                pprint.pprint(ssock.getpeercert())

                input("\033[34mTLS handshake complete\033[0m .Press Enter to close connection...")

                # Close the TLS connection
                ssock.shutdown(socket.SHUT_RDWR)
                ssock.close()
                print("\033[33m>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  Option B: Downloading a Trusted CA Bundle  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\033[0m")
                 # Remove the entire './certs' directory if it exists, then recreate it.
                if os.path.exists('./certs'):
                    shutil.rmtree('./certs')
                os.makedirs('./certs')
                print("Removed and recreated './certs' directory.")

                # Download the CA bundle file (cacert.pem) from the trusted source
                print("Downloading CA bundle file to ./certs/cacert.pem ...")
                try:
                    subprocess.run("wget -O ./certs/cacert.pem https://curl.se/ca/cacert.pem",
                                shell=True, check=True)
                    print("CA bundle downloaded successfully.")
                except subprocess.CalledProcessError as e:
                    print("Error downloading CA bundle:", e)
                    return

                # Use the downloaded bundle for certificate verification
                cafile = './certs/cacert.pem'
                context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
                context.load_verify_locations(cafile=cafile)
                context.verify_mode = ssl.CERT_REQUIRED
                context.check_hostname = True

                # Create the TCP connection
                sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                sock.connect((hostname, port))
                input("\033[32mTCP connection established.\033[0m  Press Enter to start TLS handshake...")

                # Wrap the socket in TLS and perform the handshake within a try/except block
                try:
                    ssock = context.wrap_socket(sock, server_hostname=hostname, do_handshake_on_connect=False)
                    ssock.do_handshake()
                except ssl.SSLError as e:
                    print("Error during TLS handshake:", e)
                    sock.close()
                    return

                # Print the cipher suite used and the server certificate details
                print("=== Cipher Used ===")
                print(ssock.cipher())
                print("\n=== Server Certificate ===")
                pprint.pprint(ssock.getpeercert())

                input("\033[34mTLS handshake complete\033[0m. Press Enter to close connection...")

                # Close the TLS connection
                ssock.shutdown(socket.SHUT_RDWR)
                ssock.close()




def task_3(hostname, check_hostname_flag):
    """
    Task 3: Toggle hostname verification.
    check_hostname_flag must be True or False.
    """
    port = 443
    cadir = '/etc/ssl/certs'

    # TLS context with dynamic hostname checking
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
    context.load_verify_locations(capath=cadir)
    context.verify_mode = ssl.CERT_REQUIRED
    context.check_hostname = check_hostname_flag

    print(f"[*] context.check_hostname = {context.check_hostname}")

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((hostname, port))
    input("\033[32mTCP connection established\033[0m Press Enter to start TLS handshake...")

    try:
        ssock = context.wrap_socket(
            sock, server_hostname=hostname, do_handshake_on_connect=False
        )
        ssock.do_handshake()
    except ssl.CertificateError as ce:
        print("\033[31mCertificateError:\033[0m", ce)
        sock.close()
        return
    except ssl.SSLError as se:
        print("SSLError during handshake:", se)
        sock.close()
        return

    print("=== Cipher Used ===", ssock.cipher())
    print("\n=== Server Certificate ===")
    pprint.pprint(ssock.getpeercert())

    input("\033[32mTLS handshake complete\033[0m. Press Enter to close connection...")
    ssock.shutdown(socket.SHUT_RDWR)
    ssock.close()





def task_4(hostname, resource="/"):
    """
    Task 4: Send an HTTP request over TLS and read the response.
      - hostname: the server to connect to
      - resource: the HTTP path to fetch (e.g. "/", or "/image.png")
    """
    port = 443
    cadir = '/etc/ssl/certs'

    # 1) TLS context setup
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
    context.load_verify_locations(capath=cadir)
    context.verify_mode = ssl.CERT_REQUIRED
    context.check_hostname = True

    # 2) Establish TCP connection
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((hostname, port))
    input("TCP connected. Press Enter to start TLS handshake...")

    # 3) TLS handshake
    ssock = context.wrap_socket(sock, server_hostname=hostname,
                                do_handshake_on_connect=False)
    ssock.do_handshake()
    print("[+] TLS handshake complete")

    # 4) Build and send HTTP request
    req = f"GET {resource} HTTP/1.0\r\nHost: {hostname}\r\n\r\n"
    ssock.sendall(req.encode('utf-8'))
    print(f"[>] Sent HTTP GET {resource}")

    # 5) Receive and handle response
    # If it’s an image (by extension), save raw bytes to a file
    ext = os.path.splitext(resource)[1].lower()
    if ext in (".png", ".jpg", ".jpeg", ".gif"):
        filename = resource.strip("/").split("/")[-1] or "downloaded_image"
        with open(filename, "wb") as f:
            while True:
                data = ssock.recv(2048)
                if not data:
                    break
                f.write(data)
        print(f"[+] Image saved as {filename}")
    else:
        # Otherwise, treat it as text and pretty-print each line
        data = ssock.recv(2048)
        while data:
            pprint.pprint(data.split(b"\r\n"))
            data = ssock.recv(2048)

    # 6) Clean up
    ssock.shutdown(socket.SHUT_RDWR)
    ssock.close()


                
                
                        



if __name__ == "__main__":
    # Expecting the first argument to be the function name ("task_1") and the second argument to be the hostname.
    if len(sys.argv) == 3 and sys.argv[1] == "task_1":
        hostname = sys.argv[2]
        task_1(hostname)
    
    elif len(sys.argv)==3 and sys.argv[1]=="task_2":
        hostname = sys.argv[2]
        task_2(hostname)
    
    elif len(sys.argv) == 4 and sys.argv[1] == "task_3":
        hostname = sys.argv[2]
        flag = sys.argv[3].lower() in ("true", "1", "yes")
        task_3(hostname, flag) 
    elif len(sys.argv) >= 3 and sys.argv[1] == "task_4":
        hostname = sys.argv[2]
        resource = sys.argv[3] if len(sys.argv) >= 4 else "/"
        task_4(hostname, resource)       
    else:
        print("invalid function")