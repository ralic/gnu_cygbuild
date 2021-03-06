#!/bin/sh
# Copyright (C) YYYY Firstname Lastname; Licensed under GPL v2 or later
#
# This file runs with command [all]. Prepare package for configure
# and build phase, which means applying the cygwin specific patch etc.
#
#   CYGWIN-PACKAGES/prepare.sh <src-upacked-path>

Main()
{
    if [ $# -ne 1 ]; then
        echo "$0: Invalid number of arguments."
        exit 1
    fi

    srcdir="$1"

    cd $srcdir || exit 1

    #  Now do whatever is needed, call e.g:
    #  CygbuildCmdPrepPatch
}

Main "$@"

# End of file
