.PHONY: setup install run-master run-chunks run stop clean

UV := uv
PYTHON := python3 -u
MASTER_DIR := master
CHUNK_DIR := chunk
MASTER_PID := master.pid
CHUNK_PIDS_DIR := chunk_pids
CHUNK_DATA_DIR := ./chunk/chunk_data
LOGS_DIR := logs

# Ensure chunk pid dir exists
$(CHUNK_PIDS_DIR):
	mkdir -p $(CHUNK_PIDS_DIR)

setup: install
	mkdir -p $(CHUNK_DIR) $(CHUNK_DATA_DIR) $(CHUNK_PIDS_DIR) $(LOGS_DIR) $(MASTER_DIR)

install: pyproject.toml
	$(UV) sync

# Start master server (writes PID to master.pid and logs to master.log)
run-master: $(CHUNK_PIDS_DIR)
	@echo "Starting Master Server..."
	@nohup $(PYTHON) master/master_server.py > $(LOGS_DIR)/master.log 2>&1 & \
		echo $$! > ./$(MASTER_PID)

# Start chunk servers (stores PIDs inside chunk_pids/ and logs to chunk_x.log)
run-chunks: $(CHUNK_PIDS_DIR)
	@echo "Starting 16 Chunk Servers (5000–5015)..."
	@for i in $$(seq 0 15); do \
		hex=$$(printf '%x' $$i); \
		nohup $(PYTHON) $(CHUNK_DIR)/chunk_server.py $$hex > $(LOGS_DIR)/chunk_$$hex.log 2>&1 & \
		pid=$$!; \
		echo $$pid > $(CHUNK_PIDS_DIR)/chunk_$$hex.pid; \
		echo "Chunk $$hex started (PID=$$pid)"; \
	done

run: install run-master run-chunks
	@echo ""
	@echo "---------------------------------------------"
	@echo "All servers launched."
	@echo "Access the web UI: http://localhost:8000"
	@echo "Run 'make stop' to shut everything down."
	@echo "---------------------------------------------"

# Stop servers safely
stop:
	@echo "Stopping Master Server..."
	@if [ -f $(MASTER_PID) ]; then \
		masterpid=$$(cat $(MASTER_PID)); \
		if kill -0 $$masterpid 2>/dev/null; then \
			kill $$masterpid 2>/dev/null || true; \
			echo "Killed master (PID $$masterpid)"; \
		else \
			echo "Master PID $$masterpid not running"; \
		fi; \
		rm -f $(MASTER_PID); \
	else \
		echo "No master.pid found"; \
	fi

	@echo "Stopping Chunk Servers..."
	@if compgen -G "$(CHUNK_PIDS_DIR)/*.pid" > /dev/null 2>&1; then \
		for pidfile in $(CHUNK_PIDS_DIR)/*.pid; do \
			p=$$(cat $$pidfile); \
			if kill -0 $$p 2>/dev/null; then \
				kill $$p 2>/dev/null || true; \
				echo "Killed chunk PID $$p"; \
			else \
				echo "Chunk PID $$p not running"; \
			fi; \
			rm -f $$pidfile; \
		done; \
	else \
		echo "No chunk PID files to stop"; \
	fi

	@echo "All servers stopped."

clean:
	rm -f $(MASTER_PID)
	rm -rf $(CHUNK_PIDS_DIR)
	rm -rf $(CHUNK_DATA_DIR)
	rm -rf $(LOGS_DIR)
	echo "" > ./master/file_index.json

