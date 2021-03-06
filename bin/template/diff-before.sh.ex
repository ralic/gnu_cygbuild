#!/bin/sh
# Copyright (C) YYYY Firstname Lastname; Licensed under GPL v2 or later
#
# This file runs BEFORE the diff(1) command is run
# It used to clean some files that may be on the way; like dangling symlinks
# from original packagage or if package ships compiled files.
#
#   CYGWIN-PACKAGES/diff-before.sh <orig-src-path> <cur-src-path>

Main()
{
    if [ $# -ne 2 ]; then
        echo "$0: Invalid number of arguments."
        exit 1
    fi

    orig="$1"
    now="$2"

    #  Now do whatever is needed
}

Main $*

# End of file
