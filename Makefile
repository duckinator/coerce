.PHONY: all test clean

all:
	mkdir -p generated
	greg coerce.leg > generated/parser.c
	rock -sourcepath=source coerce.ooc generated/parser.c -outpath=generated -v -g -nolines

test:
	./coerce tests/assign.coere
	./coerce tests/multiline.coere
	./coerce tests/number.coere
	./coerce tests/print.coere
	./coerce tests/lambda.coere

clean:
	rm -rf generated coerce .libs tests/assign tests/lambda tests/multiline tests/number tests/print tests/*.c

