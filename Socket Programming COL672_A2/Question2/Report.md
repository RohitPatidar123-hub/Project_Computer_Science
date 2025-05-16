#### Client Code:

- The client reads the server IP, port, packet size, and maximum word count from the config.json file.
- It establishes a connection with the server and receives an assigned client ID.
- The client sends an offset to the server, receives words, and accumulates them.
- After processing the received words, the client writes the word counts to a file named output_<client_id>.txt.

#### Server Code:

- The server reads its configuration from config.json, including the IP, port, packet size, and input file.
- It loads words from a CSV file into memory.
- The server listens for incoming client connections using a TCP socket.
- Upon receiving a connection, it assigns a client ID and spawns a thread to handle the client.
- The server sends words in batches based on the client’s requested offset and packet size.
- After serving the client, it sends an "EOF" message and closes the connection.

Lower client numbers (e.g., 1-4): Completion time per client is expected to remain relatively consistent, as the server can handle requests with little contention.
Higher client numbers (e.g., 16-32): We would observe that the completion time per client increases as more clients are introduced. This increase happens because server resources (CPU, bandwidth, etc.) are shared, leading to contention.