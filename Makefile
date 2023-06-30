.PHONY: all build test

all:

build:
	bash script/embed_argparse.bash

lint:
	@shellcheck cdr

test:
	@bats test
