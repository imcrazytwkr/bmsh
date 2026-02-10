[![license](https://img.shields.io/github/license/imcrazytwkr/bmsh)](LICENSE)

An extremely simple tool that keeps your bookmarks in a tab-separated config
file and opens them in your browser or file manager (for `file://...` URLs).

## Getting started

These instructions will get you a copy of the project up and running on your local machine
for day-to-day usage, development and testing purposes. Since this tool is a quick and
dirty solution, it is not intended for multi-user packaging. I may change this stance
and add multi-user support later on.

### Prerequisites

Any POSIX-compatible shell (all executables have shebangs of `/bin/sh`) for the main script,
[fzf](https://github.com/junegunn/fzf) for `fzf` menu provider,
[fuzzel](https://codeberg.org/dnkl/fuzzel) for `fuzzel` menu provider.

Additionally, installation is automated with `make`. Makefile has been tested with
[GNU](https://www.gnu.org/software/make/) implementation on Linux and
[BSD](https://man.freebsd.org/cgi/man.cgi?make(1)) implementation on macOS.

### Local installation

1. Make sure that you have `$HOME/.local/bin` directory in your `$PATH`
2. Clone the repo: `git clone 'https://github.com/imcrazytwkr/bmsh'`
3. Install with make: `make install`

### Local uninstallation

> :information_source: Uninstallation script will not remove your custom
> menu providers. If you want to remove them alongside bmsh, you will
> have to do it manually. They are located in `$XDG_DATA_HOME/bmsh`.

1. Change directory into the repo: `cd /path/to/bmsh/repo`
2. Uninstall with make: `make uninstall`

## How to use

Call `bmsh`, optionally specifying a menu provider witn `-m` argument
(bundled menu providers are `fzf` and `fuzzel`), from your terminal or
bind its execution to a key combination in your DE/WM/Compositor configuration.

## Configuration

There are two things that can be "configured" when using bmsh: your bookmarks
and the menu provider.

### Bookmarks

Bookmarks file should be located at `$XDG_CONFIG_HOME/bmsh/bookmarks`
(`$HOME/.config/bmsh/bookmarks` by default). Its format is that of a
[TSV](https://en.wikipedia.org/wiki/Tab-separated_values) file with
added support for comments (lines starting with `#` are ignored).

Blank lines are also ignored and if you would like to use it for
file paths relative to your home directory, `%h` gets expanded
to the absolute path of the current user's "$HOME".

Here's an example bookmarks file:

```conf
# vim: set noexpandtab tabstop=4 shiftwidth=4:
Google	https://google.com
Discord	https://discordapp.com

# Both options work for directories
Documents   file://%h/Documents
Downloads   %h/Downloads
```

### Menu providers

Menu providers are located in `$XDG_DATA_HOME/bmsh` directory under script names of
`{{ provider_name }}.sh`. The script should acceps a clean bookmarks TSV
(as explained in the previous section) being piped into its `STDIN`. In the end
it should output a single URL for bmsh to pass onto your browser or file manager.

While custom menu provider scripts are expected to have the `.sh` extension,
you can actually use any kind of interpreter (e.g. Python or Ruby) you want,
as long as you use a valid shebang, or even write a custom provider
in a compiled language (e.g. C++ or Go) and just place it into menu providers
directory with the expected extension.

> :warning: Custom menu providers should be executable. If they aren't executable,
> bmsh will not be able to use them.

## Redistribution

Feel free to package and re-distribute this small app however you want. I would
appreciate it if you could also include the link to this repository somewhere in
the package meta.
