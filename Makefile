# Simple makefile for testing cmake commands
# Does not run cmake's configuration step
all:
	@cmake --build ./build $(ARGS)

$(MAKECMDGOALS):
	@cmake --build $(CURDIR)/build --target $@ -- $(ARGS)

.PHONY: all $(MAKECMDGOALS)
