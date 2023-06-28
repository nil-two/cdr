.PHONY: all build test

all:

build:
	bash script/embed_argparse.bash

test:
	@bats test
