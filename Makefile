.PHONY: all build test

all:

build:
	bash script/embed_argparse.bash

lint:
	@shellcheck cdr
	@bash -c 'shellcheck <(echo '"'"'#!/bin/bash'"'"'; ./cdr --wrapper bash)'

test:
	@bats test
