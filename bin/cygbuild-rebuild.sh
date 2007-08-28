#!/bin/bash
#
#   This script build everything under current top level directory.
#   Used for rebuilding Cygwin Net Release packages. The logic is:
#
#   - Ascend to every package dir (./foo/)
#   - Find latest package directory (./foo/foo-1.4/)
#   - Build everything using cygbuild.sh

NAME="cygbuild-rebuild"
VERSION="2007.0828.2310"

find='find . -type d -maxdepth 1 | grep -Eve "^\.$|-orig" | sort'

#   Run in this order. Due to way 'readmefix' works, the binary package
#   must be built twice

targets="clean configure make install pkg readmefix install pkg spkg"

prefix="****  "
error="$prefix [ERROR]"


function Help ()
{
    cat <<EOF

Call syntax: $0 [-h] [-i INCREASE] -d DIR

For more information:

  man cygbuild-rebuild.sh

EOF
}

function Package ()
{
    local pkg=$1

    #  foo-NN.NN-1.tar.bz2

    local file=$(ls *-*bz2 | grep $pkg | grep -ve "-orig" |sort -r | head -1)

    echo $file
}

function Release ()
{
    file=$1

    #  Delete .tar.gz

    file=${file%%.*}

    #  Delete everything up till "-1"

    file=${file##*-}

    echo $file
}


function Main ()
{

    local root=""
    local increase=0

    if [[ "$*" == *--help* ]]; then
        Help
        return
    fi

    if [[ "$*" == *--[Vv]ersion* ]]; then
        echo $VERSION
        return
    fi


    # ................................................. Read options ...

    while getopts "d:i:hV" arg $*
    do
      case $arg in

            increase|i)

                increase="$OPTARG"
                ;;

            help|h)

                Help
                return
                ;;

            dir|d)

                root="$OPTARG"
                ;;

            Version|V)
                echo $VERSION
                return
                ;;

      esac
    done

    shift $((OPTIND - 1))

    # ................................................ Check options ...

    if [ -z "$root" ]; then
        echo "$error option -d DIR missing"
        return
    elif [ ! -d "$root" ]; then
        echo "$error No such directory: $root"
        return
    else
        cd $root || \
        {
            echo "$error Cannot chdir to $root"
            return
        }
    fi


    if [[ $increase != *[0-9]* ]]; then
        echo "$error -i option [$increase] does not contain a number"
        return
    fi


    # ................................................. Main program ...


    local dir

    for dir in $(eval "$find")
    do
    (
        cd $dir;

        dir=${dir#*/}       #  ./sgrep => sgrep


        local file=$(Package $dir)
        local release=$(Release $file)

        if [ -z "$release"  ]; then
            echo "$error Cannot read release from $(pwd)/$file"
            continue
        fi

        release=$((release + increase))


        #  Get latest package dir

        local cmd="$find | grep $dir | sort -r | head -1"
        local pkgdir=$(eval "$cmd")

        if [ -d $pkgdir ]; then
            cd $pkgdir
            echo "$prefix  Building $(pwd)"

            cygbuild.sh -r $release $targets || return
            find .inst/

        else
            echo "$error Cannot find $dir/$pkgdir"
        fi

    );
    done;
}


Main $*

# End of file