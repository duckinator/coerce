.PHONY: all test runtests clean

all:
	mkdir -p generated
	greg coerce.leg > generated/parser.c
	rock -clang -sourcepath=source coerce.ooc generated/parser.c -outpath=generated -v -g -nolines

test:
	./coerce tests/assign.coere
	./coerce tests/multiline.coere
	./coerce tests/number.coere
	./coerce tests/print.coere
	./coerce tests/lambda.coere
	./coerce tests/list.coere

runtests: test
	(./runtests.sh)

clean:
	rm -rf generated coerce .libs tests/assign tests/lambda tests/multiline tests/number tests/print tests/*.c

