#!/bin/bash
#
# builds lgogdownload binary anew from GIT
#
VERSION="0.1.035"

#### start configuration, edit this to suit your tastes
LGOGBASEDIR="$HOME/bin/gog"
LGOGBINARY="$HOME/bin/gog/lgogdownloader"
#### end configuration

LGOGREPO="$LGOGBASEDIR/repo/lgogdownloader"
LGOGARCHIVE="$LGOGBASEDIR/repo/.archive"
LGOGLASTVERSION="$LGOGARCHIVE/currentversion.dat"


function check_for_binary()
{
    if [ "$(which $1)" = "" ]; then
        echo  "NOT INSTALLED: $1"
        echo
        echo "please install provided utility with your paket manager, must be present."
        exit 1
    fi
}

### setup and sanity checks
mkdir -p "$LGOGREPO" "$LGOGARCHIVE"

lastversion="0.0"
do_update=0

# check for used binaries
check_for_binary git
check_for_binary cmake3
check_for_binary make
check_for_binary grep
check_for_binary awk

# check saved version
if [ -x "$LGOGBINARY" ]; then
    echo "## lgogdownloader binary found, checking current version."
    $LGOGBINARY --version | awk '{ print $2; }' > $LGOGLASTVERSION
fi
[ -s "$LGOGLASTVERSION" ] && lastversion=$(cat $LGOGLASTVERSION | head -n1)

# version from GIT
if [ ! -d "$LGOGREPO/.git"   ]; then
    echo "## no local repo of lgogdownloader found, getting current one from GitHub"
    [ -d "$LGOGREPO" ] && rm -rf "$LGOGREPO"
    cd "$LGOGBASEDIR/repo"
    git clone https://github.com/Sude-/lgogdownloader.git
    if [ $? -gt 0 ]; then
	echo "## fatal: error cloning GitHub repo."
	exit 1
    fi
fi

echo "## updating from current repository."
cd  "$LGOGREPO"
git pull
if [ $? -gt 0 ]; then
    echo "## fatal: error pulling from repository."
    exit 1
fi

version_major=$(grep 'lgogdownloader LANGUAGES C CXX VERSION' $LGOGREPO/CMakeLists.txt | awk '{ print $7; }' | tr -d '\051')
version_minor=$(git rev-parse --short HEAD)
version="$version_major.$version_minor"

if [ "$lastversion" = "$version"  ]; then
    echo
    echo "LGOGDownloader is current, ($lastversion)"
    exit
fi

echo "Version Binary: $lastversion"
echo "Version GIT   : $version"

# archive
if [ "$lastversion" != "$version"  ]; then
    echo "## update $lastversion -> $version"
    if [ ! -x "$LGOGARCHIVE/lgogdownloader.$lastversion" ]; then
	    cd "$LGOGBASEDIR"
	    mv "$LGOGBINARY" "$LGOGARCHIVE/lgogdownloader.$lastversion"
	    ln -s "repo/.archive/lgogdownloader.$lastversion" "$LGOGBINARY"
    fi
fi

mkdir -p "$LGOGREPO/build"
cd "$LGOGREPO/build"
cmake3 ..
if [ $? -gt 0 ]; then
    echo "## fatal: error running cmake."
    exit 1
fi

make
if [ $? -gt 0 ]; then
    echo "## fatal: error running make."
    exit 1
fi

if [ -x "$LGOGREPO/build/lgogdownloader" ]; then
    echo -n "## checking new build number ... "
    newversion=$($LGOGREPO/build/lgogdownloader --version | awk '{ print $2; }')
    echo $newversion
    
    if [ "$newversion" != "$version"   ]; then
	    echo "## ?!? more recent build has other version than calculated?"
	    echo "calculated: $version"
	    echo "binary    : $newversion"
	    exit 1
    fi
    
    mv "$LGOGREPO/build/lgogdownloader" "$LGOGARCHIVE/lgogdownloader.$newversion"
    cd "$LGOGBASEDIR"
    [ -h "$LGOGBINARY" ] && rm -f "$LGOGBINARY"
    ln -s "repo/.archive/lgogdownloader.$newversion" "$LGOGBINARY"
    ls -l "lgogdownloader"
else
    echo "## fatal: build failed."
    exit 1
fi
