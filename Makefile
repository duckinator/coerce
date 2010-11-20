all: coerce

grammar/coere.c: grammar/coere.leg
	greg -o $@ $<

coerce: grammar/coere.c
			
clean:
	rm -rf grammar/coere.c coerce

.PHONY: clean
