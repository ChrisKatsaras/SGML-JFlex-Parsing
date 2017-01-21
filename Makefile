JAVAC=javac
JFLEX=jflex
#JFLEX=/usr/local/Cellar/jflex/1.6.1/bin/jflex

all: Scanner.class

Scanner.class:  Lexer.java Scanner.java Token.java

%.class: %.java
	$(JAVAC) $^

Lexer.java: sgml.flex
	$(JFLEX) sgml.flex

clean:
	rm -f Lexer.java *.class *~