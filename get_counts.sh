#!/bin/bash -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <files...>"
    exit 1
fi

get_counts () {
    for var in "$@"; do
        echo -n "$var: "
        echo $(python3 $SCRIPT_DIR/shrinko8/shrinko8.py --count "$var")
    done
}

get_counts "$@" | column -t | sort -k 3 -n -r
