SHELL:=/bin/bash

all: check

check: check-shellcheck

check-shellcheck:
	echo "ShellCheck $$(shellcheck --version | grep version:)"
	shellcheck -x inst/bin/mdi
