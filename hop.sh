HOPDIRS_FILE=${HOPDIRS_FILE:-~/.hopdirs}

usage="Usage: hop [-i] DIRNAME
    Hops to directories defined in "$HOPDIRS_FILE" by only using their name.

    Options:
      -i        Ignore case when searching through directory names."

IGNORECASE="${HOP_ICASE:-0}"

LOOKUP_ICASE_FLAG=
COMPREPLY_ICASE_FLAG=

if [ "$IGNORECASE" -eq 1 ]; then
    LOOKUP_ICASE_FLAG=" -i"
    COMPREPLY_ICASE_FLAG=" -v IGNORECASE=1"
fi

_hop_lookup() {
    if ! [ -f "$HOPDIRS_FILE" ]; then
        (>&2 echo "List of hop directories at path "$HOPDIRS_FILE" was not found.")
        return 1
    fi
    # Omit lines that start with # and search for query (with or without trailing /)
    echo $(sed "/^#/ d" "$HOPDIRS_FILE" | grep$LOOKUP_ICASE_FLAG "$1/\?$")
}

hop() {
    if [ "$1" = "--help" ]; then
        echo "$usage"
        return
    fi

    # These need to be local to the function
    # to prevent problems when it's rerun
    # https://stackoverflow.com/a/16655341/11114199
    local OPTIND i opts
    LOOKUP_ICASE_FLAG=
    if [ "$IGNORECASE" -eq 1 ]; then
        LOOKUP_ICASE_FLAG=" -i"
    fi
    while getopts i opts; do
        case $opts in
            i)  LOOKUP_ICASE_FLAG=" -i";;
        esac
    done

    # Remove flags from argument list after parsing
    shift "$(($OPTIND-1))"

    # If invalid arguments or first one is help
    if [ "$#" -ne 1 ]; then
        echo "$usage"
        return 1
    fi

    local dir
    dir=$(_hop_lookup "$1")
    # If error in _hop_lookup
    if [ "$?" -eq 1 ]; then
        return 1
    fi
    if ! [ -d "$dir" ]; then
        (>&2 echo "Hop directory '"$1"' was not found.")
        return 1
    fi
    cd "$dir"
}

_hop_autocomplete() {
    # Check if search needs to be case-insensitive
    COMPREPLY_ICASE_FLAG=
    # If set through the env variable
    if [ "$IGNORECASE" -eq 1 ]; then
        COMPREPLY_ICASE_FLAG=" -v IGNORECASE=1"
    fi
    # Or first argument of hop is "-i"
    if [ "${COMP_WORDS[1]}" = "-i" ]; then
        COMPREPLY_ICASE_FLAG=" -v IGNORECASE=1"
        # If first word was -i, set flag and pop it
        COMP_WORDS=("${COMP_WORDS[@]:1}")
    fi

    # Skip if no query
    if [ "${#COMP_WORDS[@]}" -ne 2 ]; then
        return
    fi
    # Remove trailing /, split by / and get last part
    # Ignore lines that start with #
    query="${COMP_WORDS[1]}"
    HOPDIRNAMES=$(sed "s/\/$//" "$HOPDIRS_FILE" | awk -F/ '/^[^#]/ {print $NF}')
    # Custom compgen to support case-insensitivity
    # https://unix.stackexchange.com/a/205097
    COMPREPLY=($(echo "$HOPDIRNAMES" | awk$COMPREPLY_ICASE_FLAG -v p="$query" 'p==substr($0,0,length(p))'))
}

if [ -f "$HOPDIRS_FILE" ]; then
    complete -F _hop_autocomplete hop
fi
