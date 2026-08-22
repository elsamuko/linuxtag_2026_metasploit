#!/usr/bin/env python3

import sqlite3
from flask import Flask, request, render_template_string, session

app = Flask(__name__)
# key for session management
# openssl rand -hex 16
app.secret_key = '77a510915b91c94b5c3d6d9bb565e488'

# Simple inline HTML template for a login form
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head><title>Vulnerable Login</title></head>
<body>
    <h2>Login Portal</h2>
    <form method="POST" action="/login">
        <label>Username:</label><br>
        <div>Try <code>' OR 1=1 --</code><div>
        <input type="text" name="username"><br><br>
        <label>Password:</label><br>
        <input type="password" name="password"><br><br>
        <input type="submit" value="Login">
    </form>
    {% if message %}
    <p><strong>Status:</strong> {{ message }}</p>
    {% endif %}
</body>
</html>
"""

def get_db_connection():
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    return conn

@app.route('/')
def home():
    return render_template_string(HTML_TEMPLATE)

@app.route('/login', methods=['POST'])
def login():
    username = request.form.get('username')
    password = request.form.get('password')
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # CRITICAL VULNERABILITY: Direct string formatting allows SQL Injection
    query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
    
    try:
        cursor.execute(query)
        user = cursor.fetchone()
        if user:
            session['user'] = user['username']
            message = f"Welcome back, {user['username']}! (Query executed: {query})"
        else:
            message = f"Login failed. (Query executed: {query})"
    except Exception as e:
        message = f"Database Error: {str(e)} (Query executed: {query})"
        
    conn.close()
    return render_template_string(HTML_TEMPLATE, message=message)

# VULNERABILITY: Broken Access Control (Privilege Escalation / Mass Assignment)
@app.route('/update_user', methods=['POST'])
def update_user():
    print("update_user called")
          
    # Only checks if authentication exists, not if the user has authorization/admin rights
    if 'user' not in session:
        print("Unauthorized: Please log in first.")
        return "Unauthorized: Please log in first.", 401

    target_user = request.form.get('username', session['user'])
    is_admin = request.form.get('admin')  # Accepts 0 or 1 directly from client input

    if is_admin is None:
        return "Missing 'admin' parameter.", 400

    conn = get_db_connection()
    cursor = conn.cursor()

    # Flawed logic: Any authenticated user can set the 'is_admin' status of any account
    query = f"UPDATE users SET is_admin = {is_admin} WHERE username = '{target_user}'"
    
    try:
        cursor.execute(query)
        conn.commit()
        message = f"Successfully updated '{target_user}' admin status to {is_admin}. (Query: {query})"
    except Exception as e:
        message = f"Database Error: {str(e)}"
    finally:
        conn.close()

    return message

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5005)