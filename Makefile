all: example

example: example.m ObjCheck.m ObjCheck.h
	gcc -o example -framework foundation example.m ObjCheck.m

clean:
	-rm example