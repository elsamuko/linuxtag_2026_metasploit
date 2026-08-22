#!/usr/bin/env python3

import sqlite3

conn = sqlite3.connect('database.db')
cursor = conn.cursor()

# Create users table
cursor.execute('''
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
    )
''')

# Insert a dummy user
cursor.execute("INSERT OR REPLACE INTO users (username, password) VALUES ('admin', 'SuperSecretPassword123')")
cursor.execute("INSERT OR REPLACE INTO users (username, password) VALUES ('user', 'notadmin')")

conn.commit()
conn.close()
print("Database initialized successfully.")
