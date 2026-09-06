#!/usr/bin/env python3

import socket
import ssl
import threading


def handle_client(conn, addr):
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    # Allow legacy protocols if supported by system OpenSSL
    context.options &= ~getattr(ssl, "OP_NO_SSLv3", 0)
    context.options &= ~getattr(ssl, "OP_NO_TLSv1", 0)
    context.options &= ~getattr(ssl, "OP_NO_TLSv1_1", 0)

    try:
        context.load_cert_chain(certfile="cert.pem", keyfile="key.pem")
        with context.wrap_socket(conn, server_side=True) as tls_conn:
            tls_conn.recv(1024)
            tls_conn.sendall(b"HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK")
    except Exception:
        # Silently absorb failed handshake probes from scanner
        pass
    finally:
        try:
            conn.close()
        except Exception:
            pass


def run_server():
    bind_ip = "0.0.0.0"
    bind_port = 5005

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((bind_ip, bind_port))
    server.listen(5)
    print(f"[*] Listening on {bind_ip}:{bind_port}...")

    while True:
        client_sock, addr = server.accept()
        client_handler = threading.Thread(target=handle_client, args=(client_sock, addr))
        client_handler.start()


if __name__ == "__main__":
    run_server()
