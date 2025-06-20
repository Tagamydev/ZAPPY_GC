import socket
import argparse
import random
import time
import sys


def parse_args():
    parser = argparse.ArgumentParser(description="Game server simulation")
    parser.add_argument('--fstart', required=True,
                        help='Path to the start file to send after GRAPHIC keyword')
    parser.add_argument('--fruntime', required=True,
                        help='Path to the runtime file with strings to send randomly')
    parser.add_argument('--host', default='0.0.0.0',
                        help='Host to bind the server to')
    parser.add_argument('--port', type=int, default=4242,
                        help='Port to listen on')
    parser.add_argument('--min-delay', type=float, default=0.5,
                        help='Minimum delay between runtime messages (seconds)')
    parser.add_argument('--max-delay', type=float, default=2.0,
                        help='Maximum delay between runtime messages (seconds)')
    return parser.parse_args()


def send_and_log(conn, message):
    '''Send a message to the client and print it to the server terminal.'''
    if not message.endswith('\n'):
        message += '\n'
    conn.sendall(message.encode('utf-8'))
    print(f"Sent: {message.strip()}")


def main():
    args = parse_args()

    # Read startup file content
    try:
        with open(args.fstart, 'r') as f:
            start_content = f.read()
    except Exception as e:
        print(f"Failed to read start file: {e}")
        sys.exit(1)

    # Read runtime lines
    try:
        with open(args.fruntime, 'r') as f:
            runtime_lines = [line.strip() for line in f if line.strip()]
    except Exception as e:
        print(f"Failed to read runtime file: {e}")
        sys.exit(1)

    HOST, PORT = args.host, args.port
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.bind((HOST, PORT))
        sock.listen(1)
        print(f"Listening on {HOST}:{PORT}...")

        conn, addr = sock.accept()
        with conn:
            print(f"Connected by {addr}")

            # Send initial welcome message
            send_and_log(conn, "Welcome to the game server!")

            # Wait for the GRAPHIC keyword
            data = conn.recv(1024).decode('utf-8').strip()
            print(f"Received from client: {data}")
            if data.upper() == 'GRAPHIC':
                # Send start file content
                for line in start_content.splitlines():
                    send_and_log(conn, line)

                # Send runtime lines at random intervals
                for line in runtime_lines:
                    delay = random.uniform(args.min_delay, args.max_delay)
                    time.sleep(delay)
                    send_and_log(conn, line)

                print("All runtime messages sent; exiting.")
            else:
                print("Did not receive GRAPHIC keyword; closing connection.")

    print("Server shutting down.")


if __name__ == '__main__':
    main()
