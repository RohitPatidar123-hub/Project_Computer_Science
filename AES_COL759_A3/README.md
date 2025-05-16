Steps to run

1) Run database.py to setup the database

```sh
python3 database.py
```

2) Start the server

```sh
python3 server.py
```

3) Connect the client to the server

```sh
python3 client.py <Username>
```

4) To check the data in database

```sh
sqlite3 messages.db
```

Then to list the data, do:

```sh
SELECT * FROM messages;
```

5) To decrypt the data present in the database to confirm if it is correct or not

```sh
python3 decrypt_messages.py
```
