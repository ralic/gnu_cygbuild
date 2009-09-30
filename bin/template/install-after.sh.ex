#!/bin/sh
# Copyright (C) YYYY Firstname Lastname; Licensed under GPL v2 or later
#
# install-after.sh -- Custom installation
#
# The script will receive arguments:
#
#    $ install-after.sh .inst <install-dir> <PKG> <VER> <caller-prg>
#
# This script is run after [install] command. NOTE: Echo all messages
# with ">> " prefix".

PATH="/sbin:/usr/sbin/:/bin:/usr/bin:/usr/X11R6/bin"
LC_ALL="C"

set -e

Cmd()
{
    echo "$@"
    [ "$test" ] && return
    "$@"
}

Main()
{
    root=${1:-".inst"}
    pkg=$2
    ver=$3
    caller=$4

    if [ ! "$root"  ] || [ ! -d "$root" ]; then
        echo "$0: [ERROR] In $(pwd) no such directory: '$root'" >&2
        return 1
    fi

    root=$(echo $root | sed 's,/$,,')  # Delete trailing slash
    bindir=$root/usr/bin
    sharedir=$root/usr/share
    emacsdir=$sharedir/emacs/site-lisp
    mandir=$sharedir/man/man1

    docdir=$(cd $root/usr/share/doc/[a-zA-Z]*-*[0-9] && pwd)
    docpkg=$(cd $root/usr/share/doc/[a-z]*[a-zA-Z] && pwd)

    [ "$docdir" ] || return 0
    [ "$docpkg" ] || return 0

    # example 1) Copy whole 'doc' directory to package dir
    echo ">> Relocating doc directory"
    Cmd mv $root/doc $root/usr/share/doc

    # example 2) copy xxx.sh to package dir
    echo ">> Relocating xxx.sh directory"
    Cmd install -m 755 $root/usr/share/bin/xxx.sh $root/usr/bin
    Cmd rm $root/usr/share/bin/xxx.sh
}

Main "$@"

# End of file