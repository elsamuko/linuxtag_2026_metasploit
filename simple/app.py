#!/usr/bin/env python3
# openssl req -x509 -newkey rsa:4096 -nodes -out cert.pem -keyout key.pem -days 365 -subj "/CN=localhost"
# openssl s_server -accept 5005 -www -key key.pem -cert cert.pem

from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "<h1>Home Page</h1><p>Welcome to the HTTPS Flask App!</p><a href='/about'>About</a> | <a href='/contact'>Contact</a>"

@app.route("/about")
def about():
    return "<h1>About Page</h1><p>This is a custom 3-page Flask application.</p><a href='/'>Home</a> | <a href='/contact'>Contact</a>"

@app.route("/secret")
def secret():
    return "Unlisted secret page"

@app.route("/contact")
def contact():
    return "<h1>Contact Page</h1><p>Get in touch with us here.</p><a href='/'>Home</a> | <a href='/about'>About</a>"

if __name__ == "__main__":
    # Pass the certificate and key files directly into the ssl_context parameter
    app.run(ssl_context=('cert.pem', 'key.pem'), host="0.0.0.0", port=5005)
