# this install script was unashamedly ripped from install.meteor.com, which is a sweet example. 
# 201406191949

echo "Installing ruby gem 'parseconfig'"
sudo gem install parseconfig

TARBALL_URL="http://github.com/jonS90/WordSafe/tarball/master"

UNAME=$(uname)
if [ "$UNAME" != "Linux" -a "$UNAME" != "Darwin" ] ; then
    echo "Sorry, this OS is not supported yet."
    exit 1
fi

set -e
set -u

trap "echo Installation failed." EXIT


INSTALL_TMPDIR="$HOME/.wordsafe-install-tmp"
rm -rf "$INSTALL_TMPDIR"
mkdir "$INSTALL_TMPDIR"
echo "Downloading WordSafe"
curl -L --progress-bar --fail "$TARBALL_URL" | tar -xzf - -C "$INSTALL_TMPDIR"
if [ ! -x "${INSTALL_TMPDIR}/"*/wordsafe ] ; then
	echo "Download failed."
	exit
fi



PREFIX="/usr/local"
  # New macs (10.9+) don't ship with /usr/local, however it is still in
  # the default PATH. We still install there, we just need to create the
  # directory first.
  if [ ! -d "$PREFIX/bin" ] ; then
      sudo mkdir -m 755 "$PREFIX" || true
      sudo mkdir -m 755 "$PREFIX/bin" || true
  fi

if sudo cp "$INSTALL_TMPDIR/"*/wordsafe "$PREFIX/bin/"; then
  cat <<"EOF"

WordSafe has been installed. To get started fast:

  $ wordsafe --new my_cool_journal
  $ wordsafe my_cool_journal

Or check out the help text:

  $ wordsafe --help

EOF
  else
    cat <<"EOF"

Couldn't write to /usr/local/bin. I think you need to rerun this as root.

EOF
fi

rm -rf "$INSTALL_TMPDIR"

trap - EXIT
