# Simple makefile for testing cmake commands
# Does not run cmake's configuration step
$(MAKECMDGOALS):
	@cmake --build $(CURDIR)/build --target $@ -- $(ARGS)

.PHONY: $(MAKECMDGOALS)
