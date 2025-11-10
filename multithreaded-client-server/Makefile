help:
	@echo "Usage: make [compile|client|server|clean]"

%.class: %.java
	javac $<

.PHONY: compile
compile: clean *.class

.PHONY: client
client: ChatClient.class
	java ChatClient

.PHONY: server
server: ChatServer.class
	java ChatServer

.PHONY: clean
clean:
	rm -f *.class
