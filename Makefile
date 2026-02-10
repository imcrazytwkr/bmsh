mkfile_dir := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

prefix = ${HOME}/.local

bin_prefix := $(prefix)/bin
cmd_prefix := $(prefix)/share/bmsh

CMDS := $(wildcard $(mkfile_dir)/commands/*.sh)
MAIN := $(mkfile_dir)/bmsh.sh

.PHONY: format lint install uninstall

format:
	shfmt -l -w '$(MAIN)' $(foreach C,$(CMDS),'$C')

lint: format
	shellcheck '$(MAIN)' $(foreach C,$(CMDS),'$C')

# @NOTE: for `install -T` [SOURCE] comes before [DEST],
# for `install -t` it's the other way round
install:
	install -Dm755 -t '$(cmd_prefix)' $(foreach C,$(CMDS),'$C')
	install -Dm755 -T '$(MAIN)' '$(bin_prefix)/bmsh'

uninstall:
	rm -f $(foreach C,$(notdir $(CMDS)),'$(cmd_prefix)/$C')
	rmdir --ignore-fail-on-non-empty '$(cmd_prefix)'
	rm -f '$(bin_prefix)/bmsh'
