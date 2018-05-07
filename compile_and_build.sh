if [ $# -eq 0 ]
then
  echo "You must supply a Ruby version"
  exit 1
fi

RUBY_BUILD_DIR="/tmp/ruby-build/"
TIMESTAMP=$(date +%s)
COMPILE_DEST="$RUBY_BUILD_DIR/ruby-jemalloc-$TIMESTAMP"
DEFINITION_FILE_TEMPLATE="definition"
RUBY_VERSION=$1
DEFINITION_FILE=$RUBY_VERSION-package

echo "Cloning and installing Ruby-Build"
git clone https://github.com/rbenv/ruby-build.git
PREFIX=/usr/local ./ruby-build/install.sh

echo "Creating necessary directories"
mkdir $RUBY_BUILD_DIR
mkdir $COMPILE_DEST

echo "Copying DEBIAN directory"
cp -r /DEBIAN $COMPILE_DEST

echo "Creating definition file"
touch $DEFINITION_FILE
cat $DEFINITION_FILE_TEMPLATE >> $DEFINITION_FILE

echo "Compiling Ruby"
env RUBY_CONFIGURE_OPTS="--with-jemalloc --disable-install-doc" RUBY_MAKE_INSTALL_OPTS="DESTDIR=$COMPILE_DEST" RUBY_PREFIX_PATH="/usr" ruby-build $DEFINITION_FILE $COMPILE_DEST -v

echo "Building debian package"
dpkg-deb --build $COMPILE_DEST
