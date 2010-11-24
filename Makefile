.PHONY: all test runtests clean

all: coerce

coerce:
	mkdir -p generated
	greg coerce.leg > generated/parser.c
	rock -clang -sourcepath=source coerce.ooc generated/parser.c -outpath=generated -v -g -nolines

test: coerce
	./coerce tests/assign.coere
	./coerce tests/multiline.coere
	./coerce tests/number.coere
	./coerce tests/negative_number.coere
	./coerce tests/print.coere
	./coerce tests/lambda.coere
	./coerce tests/list.coere
	./coerce tests/string.coere
	./coerce tests/char.coere
	./coerce tests/bool.coere

runtests: test
	(./runtests.sh)

clean:
	rm -rf generated coerce .libs tests/assign tests/lambda tests/multiline tests/number tests/negative_number tests/print tests/list tests/string tests/char tests/bool tests/*.c

