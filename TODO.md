# TODO

#### OS support
- support for running on Windows subsystems (cygwin, MSYS, Ubuntu on Windows)
- support for running under OSX
- support for a proper native Windows version may be a challenge

#### Building
- encapsulation of distribution-specific idiosyncracies (Debian family, RedHat family, Slackware to mention)
- support for automatically getting and installing lgogdownloader and update-lgogdownloader dependencies. This
will be in an extra script, because this obviously needs to be run with root privileges
(package installation)
- support for building proper packages (tarball, DEB, RPM, TGZ (Slackware/SlackBuild))
- support for lgogdownloader-specific options
