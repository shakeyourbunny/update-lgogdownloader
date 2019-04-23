#!/bin/bash
#
# aktualisiert den lgogdownloader aus GIT
#
#CMAKE="/opt/cmake/bin/cmake"
CMAKE=$(which cmake3)

LGOGBASEDIR="$HOME/bin/gog"
LGOGREPO="$LGOGBASEDIR/repo/lgogdownloader"
LGOGARCHIV="$LGOGBASEDIR/repo/.archive"
LGOGLASTVERSION="$LGOGARCHIV/currentversion.dat"

LGOGBINARY="$HOME/bin/gog/lgogdownloader"

### setup and sanity checks
mkdir -p "$LGOGREPO" "$LGOGARCHIV"

lastversion="0.0"
do_update=0

# gespeicherte version
if [ -x "$LGOGBINARY" ]; then
    echo "## lgogdownloader binary found, checking current version."
    $LGOGBINARY --version | awk '{ print $2; }' > $LGOGLASTVERSION
fi
[ -s "$LGOGLASTVERSION" ] && lastversion=$(cat $LGOGLASTVERSION | head -n1)

# version von git
if [ ! -d "$LGOGREPO/.git"   ]; then
    echo "## kein lokales gitrepo von lgogdownloader vorhanden, ziehe aktuelle Version!"
    [ -d "$LGOGREPO" ] && rm -rf "$LGOGREPO"
    cd "$LGOGBASEDIR/repo"
    git clone https://github.com/Sude-/lgogdownloader.git
    if [ $? -gt 0 ]; then
	echo "## fatal: fehler beim clonen vom repo."
	exit 1
    fi
fi


echo "## aktualisiere git repo."
cd  "$LGOGREPO"
git pull
if [ $? -gt 0 ]; then
    echo "## fatal: fehler beim update von repo."
    exit 1
fi

version_major=$(grep 'lgogdownloader LANGUAGES C CXX VERSION' $LGOGREPO/CMakeLists.txt | awk '{ print $7; }' | tr -d '\051')
version_minor=$(git rev-parse --short HEAD)
version="$version_major.$version_minor"

if [ "$lastversion" = "$version"  ]; then
    echo
    echo "LGOGDownloader ist aktuell ($lastversion)"
    exit
fi

echo "Version Binary: $lastversion"
echo "Version GIT   : $version"


# archiv
if [ "$lastversion" != "$version"  ]; then
    echo "## update $lastversion -> $version"
    if [ ! -x "$LGOGARCHIV/lgogdownloader.$lastversion" ]; then
	cd "$LGOGBASEDIR"
	mv "$LGOGBINARY" "$LGOGARCHIV/lgogdownloader.$lastversion"
	ln -s "repo/.archive/lgogdownloader.$lastversion" "$LGOGBINARY"
    fi
fi

if [ ! -x $CMAKE  ]; then
    echo "## fatal: cmake bitte richtig installieren (auf $CMAKE)."
    exit 1
fi

mkdir -p "$LGOGREPO/build"
cd "$LGOGREPO/build"
$CMAKE ..
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
    echo -n "## checke neue buildnummer... "
    newversion=$($LGOGREPO/build/lgogdownloader --version | awk '{ print $2; }')
    echo $newversion
    
    if [ "$newversion" != "$version"   ]; then
	echo "## ?!? neuer build hat andere Version als errechnet?"
	echo "errechnet: $version"
	echo "binary   : $newversion"
	exit 1
    fi
    
    mv "$LGOGREPO/build/lgogdownloader" "$LGOGARCHIV/lgogdownloader.$newversion"
    cd "$LGOGBASEDIR"
    [ -h "$LGOGBINARY" ] && rm -f "$LGOGBINARY"
    ln -s "repo/.archive/lgogdownloader.$newversion" "$LGOGBINARY"
    ls -l "lgogdownloader"
else
    echo "## fatal: build failed."
    exit 1
fi