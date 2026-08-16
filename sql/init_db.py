#!/usr/bin/env python3

import sqlite3

conn = sqlite3.connect('database.db')
cursor = conn.cursor()

# Create users table
cursor.execute('''
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        username TEXT NOT NULL,
        password TEXT NOT NULL
    )
''')

# Insert a dummy user
cursor.execute("INSERT INTO users (username, password) VALUES ('admin', 'SuperSecretPassword123')")

conn.commit()
conn.close()
print("Database initialized successfully.")
