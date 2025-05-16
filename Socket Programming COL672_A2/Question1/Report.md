#### Client Code:

- The client reads the server's configuration (IP, port, packet size) from a config.json file.
- It establishes a TCP connection to the server using the provided IP and port.
- The client sends requests to the server by sending an offset, which determines the starting point for the server’s response.
- The client receives words in chunks from the server, updates their frequency, and writes the frequencies to an output file.

#### Server Code:

- The server reads its configuration and loads words from a CSV file.
- It sets up a TCP socket, binds it to a specified IP and port, and starts listening for client connections.
- Upon accepting a connection, it receives an offset from the client, indicating where to start reading words.
- The server sends a specified number of words (based on PACKET_SIZE) back to the client.
- If the offset is beyond the word list, the server sends an "End of connection" message.
- After serving each client, the server closes the connection and waits for the next client.

Smaller p values (e.g., 1): You would likely observe higher completion times because each word is sent individually, which results in more packets being transmitted. This increases overhead due to more frequent TCP handshakes, acknowledgments, and other protocol overheads.
Larger p values (e.g., 10): You would see a decrease in completion time because more words are being sent in each packet, which reduces the overhead and the number of packets that need to be transmitted.