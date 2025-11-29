import os
import hashlib
import json
import threading
from flask import Flask, request, jsonify, send_from_directory
import requests
from apscheduler.schedulers.background import BackgroundScheduler

# --- Configuration ---
app = Flask(__name__, static_folder='../client', static_url_path='')
app.config['UPLOAD_FOLDER'] = '../uploads'

if not os.path.exists(app.config['UPLOAD_FOLDER']):
    os.makedirs(app.config['UPLOAD_FOLDER'])

# --- State Management ---
FILE_INDEX_PATH = './master/file_index.json'
file_index = {}
file_index_lock = threading.Lock()

CHUNK_SERVERS = {
    hex(i)[2:]: {
        "url": f"http://localhost:{5000 + i}",
        "online": False
    } for i in range(16)
}

# --- File Index Persistence ---
def load_file_index():
    """Loads the file index from a JSON file, safe even if file is empty or corrupted."""
    global file_index
    if os.path.exists(FILE_INDEX_PATH):
        try:
            with open(FILE_INDEX_PATH, 'r') as f:
                content = f.read().strip()
                if content == "":
                    file_index = {}
                else:
                    file_index = json.loads(content)
        except (json.JSONDecodeError, ValueError):
            print("Warning: file_index.json is corrupted. Reinitializing it.")
            file_index = {}
            save_file_index()
    else:
        file_index = {}
        save_file_index()

def save_file_index():
    """Saves the file index to a JSON file."""
    with file_index_lock:
        with open(FILE_INDEX_PATH, 'w') as f:
            json.dump(file_index, f, indent=4)

# --- Core Logic ---
def get_chunk_servers_for_file(file_content):
    """
    Calculates the SHA256 hash and determines target chunk servers.
    Returns the hash and a list of 3 unique chunk server IDs.
    """
    hasher = hashlib.sha256()
    hasher.update(file_content)
    file_hash = hasher.hexdigest()

    unique_chars = []
    for char in file_hash:
        if char not in unique_chars:
            unique_chars.append(char)
        if len(unique_chars) == 3:
            break
    
    if len(unique_chars) < 3:
        # Pad with the first characters if not enough unique ones are found
        unique_chars.extend(list(file_hash[:3-len(unique_chars)]))

    return file_hash, unique_chars

# --- Health Checks ---
def check_chunk_servers():
    """Background task to ping chunk servers for health."""
    for chunk_id, info in CHUNK_SERVERS.items():
        try:
            response = requests.get(f"{info['url']}/ping", timeout=2)
            info['online'] = response.status_code == 200
        except requests.RequestException:
            info['online'] = False


# --- API Endpoints ---
@app.route('/', methods=['GET'])
def serve_client():
    """Serves the main web client page."""
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/status', methods=['GET'])
def get_status():
    """Returns the current status of all chunk servers."""
    return jsonify(CHUNK_SERVERS)

@app.route('/files', methods=['GET'])
def list_files():
    """Returns a list of all available files."""
    with file_index_lock:
        # Return a simplified list of filenames and sizes
        file_list = {
            filename: {"size": data["size"], "timestamp": data["timestamp"]}
            for filename, data in file_index.items()
        }
    return jsonify(file_list)

@app.route('/upload', methods=['POST'])
def upload_file():
    """Handles file uploads, hashing, and distribution to chunk servers."""
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    file_content = file.read()
    filename = file.filename
    
    if not file_content:
        return jsonify({"error": "File is empty"}), 400

    file_hash, chunk_ids = get_chunk_servers_for_file(file_content)

    # Check which of the target chunk servers are online
    online_chunk_ids = [cid for cid in chunk_ids if CHUNK_SERVERS[cid]['online']]

    if len(online_chunk_ids) == 0:
        return jsonify({
            "error": "No available chunk servers to store the file.",
            "message": f"Required chunks: {chunk_ids}"
        }), 503

    # Distribute file to online chunk servers
    success_uploads = 0
    for cid in online_chunk_ids:
        try:
            url = f"{CHUNK_SERVERS[cid]['url']}/store/{file_hash}"
            response = requests.post(url, data=file_content, timeout=5)
            if response.status_code == 201:
                success_uploads += 1
            else:
                print(f"Error storing on chunk {cid}: {response.text}")
        except requests.RequestException as e:
            print(f"Failed to connect to chunk {cid}: {e}")

    if success_uploads == 0:
        return jsonify({"error": "Failed to store the file on any chunk server."}), 500

    # Update and save the file index
    with file_index_lock:
        file_index[filename] = {
            "hash": file_hash,
            "size": len(file_content),
            "chunk_servers": chunk_ids, # Store the ideal list of chunks
            "timestamp": request.date
        }
    save_file_index()
    
    return jsonify({
        "message": f"File '{filename}' uploaded successfully.",
        "hash": file_hash,
        "stored_on_chunks": online_chunk_ids,
        "total_replicas_stored": success_uploads
    }), 201

@app.route('/files/<filename>', methods=['GET'])
def get_file(filename):
    """Retrieves a file by fetching it from an available chunk server."""
    with file_index_lock:
        if filename not in file_index:
            return jsonify({"error": "File not found"}), 404
        
        file_info = file_index[filename]
        file_hash = file_info['hash']
        chunk_ids = file_info['chunk_servers']

    # Try to fetch from chunk servers in order
    for cid in chunk_ids:
        if CHUNK_SERVERS[cid]['online']:
            try:
                url = f"{CHUNK_SERVERS[cid]['url']}/retrieve/{file_hash}"
                response = requests.get(url, stream=True, timeout=5)
                if response.status_code == 200:
                    return response.raw.read(), 200, {'Content-Type': 'application/octet-stream'}
            except requests.RequestException as e:
                print(f"Chunk {cid} failed during file retrieval: {e}")
                continue # Try the next replica

    return jsonify({"error": "File unavailable. All replicas are offline."}), 503


if __name__ == '__main__':
    # Load the initial file index
    load_file_index()

    # Start the health checker
    scheduler = BackgroundScheduler()
    scheduler.add_job(check_chunk_servers, 'interval', seconds=5, id='chunk_health_check')
    scheduler.start()
    
    # Run initial check immediately
    check_chunk_servers()

    print("Starting Master Server on port 8000...")
    try:
        app.run(host='0.0.0.0', port=8000, debug=False)
    finally:
        scheduler.shutdown()
