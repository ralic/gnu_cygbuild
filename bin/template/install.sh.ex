#!/bin/bash
# Copyright (C) YYYY Firstname Lastname; Licensed under GPL v2 or later
#
# install.sh -- Custom installation steps
#
# The script will receive one argument: relative path to
# installation root directory. Script is called like:
#
#    $ ./CYGWIN-PATCHES/install.sh .inst/ <path of calling cygbuild>
#
#
# -- THIS AN EXAMPLE: MODIFY AS NEEDED     --
# -- DELETE FUNCTIONS THAT YOU DO NOT NEED --

PATH="/sbin:/usr/sbin/:/bin:/usr/bin:/usr/X11R6/bin"
LC_ALL="C"

DefineVariables()
{
    if [ ! "$INSTALL_BIN" ]; then
        #   Not yet loaded, so load now
        export CYGBUILD_LIB="activate as library"

        callpath="$2"

        if [ ! "$callpath" ]; then
            callpath=$(/usr/bin/which cygbuild)
        fi

        if [ "$callpath" ]; then
            . $callpath || return 1
        else
            return 1
        fi
    fi

    #   This defines many variables that can be used

    CygbuildLibInstallEnvironment "$@"
}

InstallInclude()
{
    #   -- THIS IS ONLY NEEDED IF                      --
    #   -- other packages provide same include.h files --
    #
    #   1. If there are clashing header files, they are at this point
    #      installed as package_include.sh
    #      The headers can be renamed at postinstall.sh step where each
    #      package_include.sh is symlinked to include.sh
    #
    #   2. If this is normal library which provides NEW headers, leave out
    #      '${packgae_' and the files will be installd normally

    local file

    for file in *.h
    do
         $INSTALL -D $INSTALL_BIN $file $includedir/${package}_${file}
    done
}

InstallLibraries()
{
    local file

    for file in *.a
    do
         $INSTALL -d $libdir
         $INSTALL $INSTALL_BIN $file $libdir
    done
}

InstallInfo()
{

    $INSTALL -d $infodir

    local file

    for file in doc/*.info*         # Or where package's INFO files are
    do
        $INSTALL $INSTALL_DATA $file $infodir
    done
}

InstallMan()
{
    local file
    local to
    local section=1
    local dir="man${section}"

    $INSTALL -d $mandir/$dir

    for file in doc/*.man
    do
        to=${file%.*}.$section     # .man => .1
        to=${to##*/}               # Remove path
        $INSTALL $INSTALL_DATA $file $mandir/$to
    done
}

InstallBin()
{
    $INSTALL -d $bindir

    local file=some-script.pl

    # $INSTALL $INSTALL_BIN $file $bindir

    #   If filename is too general, like in "update.pl", add a package
    #   prefix to the file

    local from=file.pl
    local to=package-file.pl

    # $INSTALL $INSTALL_BIN $from $bindir/$to

}

InstallMake()
{
    #   See what variables in the Makefile's target 'install:' are needed.
    #   and remove 'echo' to activate

    echo LANG=C make \
             DESTDIR=$(cd ${DESTDIR:-$instdir}; pwd) \
             BINDIR=$bindir \
             LIBDIR=$libdir \
             prefix=${prefix:-usr} \
             exec_prefix=${prefix:-usr} \
             install

}

Install()
{
    :
    #   This is install option (1) - All done manually; every step

    # DefineVariables "$@"  &&
    # InstallBin	    &&
    # InstallInclude	    &&
    # InstallLibraries	    &&
    # InstallInfo
}

InstallUsingMake()
{
    :
    #   This is install option (2) - using package's make(1) and then fix
    #   what's left there. Uncomment as needed:

    # DefineVariables "$@" &&
    # InstallMake
}

# -- Uncomment to active only one these function calls --
# Install "$@"
# InstallUsingMake "$@"

# End of file
