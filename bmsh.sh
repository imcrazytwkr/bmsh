#!/bin/sh

[ -z "$XDG_DATA_HOME" ] && XDG_DATA_HOME="$HOME/.local/share"

menu_cmd="$XDG_DATA_HOME/bmsh/fzf.sh"

# Parse arguments
while getopts "m:" OPT; do
	case "$OPT" in
	m)
		menu_cmd="$XDG_DATA_HOME/bmsh/${OPTARG}.sh"
		if [ ! -s "$menu_cmd" ]; then
			echo "menu provider $OPTARG is not known and does not have a script at $menu_cmd, cannot proceed." >&2
			exit 1
		fi
		;;
	*)
		echo "Usage: $0 -m <fzf|fuzzel|[custom_menu_provider]>" >&2
		exit 1
		;;
	esac
done

if [ ! -x "$menu_cmd" ]; then
	echo "Script $menu_cmd is not executable, cannot proceed." >&2
	exit 1
fi

[ -z "$XDG_CONFIG_HOME" ] && XDG_CONFIG_HOME="$HOME/.config"

bookmarks_file="$XDG_CONFIG_HOME/bmsh/bookmarks"
if [ ! -s "$bookmarks_file" ]; then
	echo "Boorkmarks file $bookmarks_file does not exist, please create it" >&2
	exit 1
fi

# `%h` is not a valid urlencoded character sequence so we can use it for safe expansion
url="$(sed -e '/^\s*#/d' -e '/^\s*$/d' -e "s|%h|$HOME|" "$bookmarks_file" | "$menu_cmd")"
[ -z "$url" ] && exit 0

command -v xdg-open >/dev/null && exec xdg-open "$url"
command -v open >/dev/null && exec open "$url"
