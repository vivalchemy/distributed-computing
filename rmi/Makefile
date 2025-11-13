help:
	@echo "Usage: make [compile|client|server|clean]"

%.class: %.java CalcInterface.java
	javac $<

.PHONY: compile
compile: clean
	javac *.java

.PHONY: client
client: CalcClient.class
	java CalcClient

.PHONY: server
server: CalcServer.class
	java CalcServer

.PHONY: clean
clean:
	rm -f *.class
