import os
import sys
from flask import Flask, request, send_from_directory, jsonify

app = Flask(__name__)

CHUNK_ID = sys.argv[1] if len(sys.argv) > 1 else '0'
BASE_DIR = os.path.abspath(os.path.dirname(__file__))
DATA_DIR = os.path.join(BASE_DIR, "chunk_data", f"chunk_{CHUNK_ID}")

if not os.path.exists(DATA_DIR):
    os.makedirs(DATA_DIR)

@app.route('/ping', methods=['GET'])
def ping():
    """Health check endpoint."""
    return jsonify({"status": "ok"}), 200

@app.route('/store/<file_hash>', methods=['POST'])
def store_file(file_hash):
    """Stores a file chunk."""
    file_path = os.path.join(DATA_DIR, file_hash)
    try:
        with open(file_path, 'wb') as f:
            f.write(request.data)
        return jsonify({"message": f"File {file_hash} stored successfully on chunk {CHUNK_ID}."}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/retrieve/<file_hash>', methods=['GET'])
def retrieve_file(file_hash):
    """Retrieves a file chunk."""
    try:
        return send_from_directory(DATA_DIR, file_hash)
    except FileNotFoundError:
        return jsonify({"error": "File not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python chunk_server.py <chunk_id_hex (0-f)>")
        sys.exit(1)

    try:
        chunk_hex = sys.argv[1]
        chunk_decimal = int(chunk_hex, 16)
        if not (0 <= chunk_decimal <= 15):
            raise ValueError()
    except ValueError:
        print("Error: Chunk ID must be a hex character between 0 and f.")
        sys.exit(1)

    port = 5000 + chunk_decimal
    print(f"Starting Chunk Server {chunk_hex} on port {port}...")
    app.run(host='0.0.0.0', port=port, debug=False)
