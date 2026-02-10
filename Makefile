mkfile_dir := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

prefix = ${HOME}/.local

bin_prefix := $(prefix)/bin
cmd_prefix := $(prefix)/share/bmsh

CMDS := $(wildcard $(mkfile_dir)/commands/*.sh)

.PHONY: format lint install uninstall

format:
	find '$(mkfile_dir)' -type f -iname '*.sh' -print0 | xargs -0 shfmt -l -w

lint: format
	find '$(mkfile_dir)' -type f -iname '*.sh' -print0 | xargs -0 shellcheck

# @NOTE: for `install -T` [SOURCE] comes before [DEST],
# for `install -t` it's the other way round
install:	
	install -Dm755 -T '$(mkfile_dir)/bmsh.sh' '$(bin_prefix)/bmsh'
	install -Dm755 -t '$(cmd_prefix)' $(foreach C,$(CMDS),'$C')

uninstall:
	rm -f $(foreach C,$(notdir $(CMDS)),'$(cmd_prefix)/$C')
	rmdir --ignore-fail-on-non-empty '$(cmd_prefix)'
	rm -f '$(bin_prefix)/bmsh'
