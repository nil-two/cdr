.PHONY: all build test

all:

lint:
	@shellcheck cdr
	@bash -c 'shellcheck <(echo '"'"'#!/bin/sh'"'"'; ./cdr --wrapper sh)'

test:
	@bats test
