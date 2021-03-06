#!/bin/sh
# Copyright (C) YYYY Firstname Lastname; Licensed under GPL v2 or later
#
# This file runs the diff(1) command to generate the patch agains original
# source package. The script is called like this:
#
#       CYGWIN-PACKAGES/diff.sh <orig-src-path> <cur-src-path> <output-file>

PATH="/sbin:/usr/sbin/:/bin:/usr/bin"
LC_ALL="C"

Main()
{
    if [ $# -ne 3 ]; then
        echo "$0: Invalid number of arguments."
        exit 1
    fi

    orig="$1"
    now="$2"
    out="$3"

    #  Now run diff(1) with options needed.
}

Main "$@"

# End of file
