# update-lgogdownloaderRWMS - RimWorld Mod Sorter
automatic building lgogdownloader from source 

[Download](https://github.com/shakeyourbunny/update-lgogdownloader/releases)

![version](https://img.shields.io/github/release/shakeyourbunny/update-lgogdownloader.svg "version")
[![Date Latest](https://img.shields.io/github/release-date/shakeyourbunny/update-lgogdownloader.svg?style=plastic)](https://github.com/shakeyourbunny/update-lgogdownloader/releases/latest)
[![Commits Since Latest](https://img.shields.io/github/commits-since/shakeyourbunny/update-lgogdownloader/latest.svg?style=plastic)](https://github.com/shakeyourbunny/update-lgogdownloader/commits/master)
![version](https://img.shields.io/github/downloads/shakeyourbunny/update-lgogdownloader/total.svg?style=plastic "version")

#### Links
Homepage: https://github.com/shakeyourbunny/update-lgogdownloader 

## Description

This bash script reduces the tedious manual downloading of Sude-'s lgogdownloader Github,
repository, cleaning up the build the directory etc  to a single command in the shell. 

Every successfully build is archived and linked.

## Requisites
- Linux (was developed and tested on CentOS7, but does not contain any distribution-specific stuff)
- installed tools: git, cmake3, make, awk, sed 
- all requisites for compiling lgogdownloader (see https://github.com/Sude-/lgogdownloader/blob/master/README.md)
- system is capable of symlinking

NOT tested on:
- OSX
- MSYS, cygwin, Ubuntu on Windows subsystem

Feedback and patches are welcome to enable this, but I suspect on Windows, you may
have to enable symlinking for non-administrative users there (see https://community.perforce.com/s/article/3472)

## Configuration
You have to change edit the environment variable LGOGBASEDIR in the script if you do
not like the default location ($HOME/bin/gog). LGOGBINARY is the symlink where the
executable will be linked to.

This script does not tackle (yet) lgogdownloader specific configuration options, but
will be included in a future revision.

## Version numbering
Last number reflects the last version of lgogdownloader release I tested the script
with, so x.x.035 means that this is update-lgogdownloader version x.x, which was tested
successfully against lgogdownloader release 0.35.

Note that the script ALWAYS pulls the most recent commit, NOT the most recent release.

## TODO
see [TODO](https://github.com/shakeyourbunny/RWMS/blob/master/TODO.md)

## Changelog
see [CHANGELOG](https://github.com/shakeyourbunny/update-lgogdownloader/blob/master/CHANGELOG) 

## Contributors
see [CONTRIBUTORS](https://github.com/shakeyourbunny/RWMS/blob/master/CONTRIBUTORS.md)

## License
Script written by shakeyourbunny <shakeyourbunny@gmail.com> 

RWMS is licensed under the GNU GPL v3.

Note that you are not allowed to take parts of the script without written permission or
give proper credit. 
