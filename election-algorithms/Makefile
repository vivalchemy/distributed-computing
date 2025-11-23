.PHONY: default run clean

default: run

%.class : %.java
	javac $<

run : Main.class
	java Main

clean:
	rm -f *.class
