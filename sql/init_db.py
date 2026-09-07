#!/usr/bin/env python3

import sqlite3
from pathlib import Path

Path('database.db').unlink(missing_ok=True)
conn = sqlite3.connect('database.db')
cursor = conn.cursor()

# Create users table
cursor.execute('''
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        is_admin BOOLEAN NOT NULL DEFAULT FALSE
    )
''')

# Insert a dummy user
cursor.execute("INSERT OR REPLACE INTO users (username, password, is_admin) VALUES ('admin', 'SuperSecretPassword123', 1)")
cursor.execute("INSERT OR REPLACE INTO users (username, password, is_admin) VALUES ('user', 'notadmin', 0)")

conn.commit()
conn.close()
print("Database initialized successfully.")
