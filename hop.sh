HOPDIRS_FILE=${HOPDIRS_FILE:-~/.hopdirs}

usage="Usage: hop DIRNAME
Hops to directories defined in "$HOPDIRS_FILE" by only using their name."

_hop_lookup() {
	if [ ! -f "$HOPDIRS_FILE" ]; then
		(>&2 echo "List of hop directories at path "$HOPDIRS_FILE" was not found.")
		return 1
	fi
	echo $(grep -i "$1/\?$" "$HOPDIRS_FILE")
}

hop() {
	# If invalid number of arguments or first one is help
	if [ "$#" -ne 1 -o "$1" = "--help" ]; then
		echo "$usage"
		return
	fi

	local dir
	dir=$(_hop_lookup "$1")
	if [ ! -d "$dir" ]; then
		(>&2 echo "Hop directory '"$1"' was not found.")
		return 1
	fi
	cd "$dir"
}

_hop_autocomplete() {
	if [[ ${#COMP_WORDS[@]} -ne 2 ]]; then
		return
	fi
	# Remove trailing /, split by / and get last part
	HOPDIRNAMES=$(sed "s/\/$//" "$HOPDIRS_FILE" | awk -F/ '{print $NF}')
	COMPREPLY=($(compgen -W "$HOPDIRNAMES" -- "${COMP_WORDS[1]}"))
}

if [ -f "$HOPDIRS_FILE" ]; then
	complete -F _hop_autocomplete hop
fi
