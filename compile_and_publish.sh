TIMESTAMP=$(date +%s)
RUBY_BUILD_DIR="/tmp/ruby-build/"
COMPILE_DEST="$RUBY_BUILD_DIR/ruby-jemalloc-$TIMESTAMP"

echo "Creating necessary directories"
mkdir $RUBY_BUILD_DIR
mkdir $COMPILE_DEST

echo "Copying DEBIAN directory"
cp -r /DEBIAN $COMPILE_DEST

echo "Cloning and installing Ruby-Build"
git clone https://github.com/rbenv/ruby-build.git
PREFIX=/usr/local ./ruby-build/install.sh

echo "Creating definition file"
touch 2.3.7-package
cat <<EOF >> 2.3.7-package
install_package "openssl-1.0.2o" "https://www.openssl.org/source/openssl-1.0.2o.tar.gz#ec3f5c9714ba0fd45cb4e087301eb1336c317e0d20b575a125050470e8089e4d" mac_openssl --if has_broken_mac_openssl
install_package "ruby-2.3.7" "https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.7.tar.bz2#18b12fafaf37d5f6c7139c1b445355aec76baa625a40300598a6c8597fc04d8e" ldflags_dirs standard
EOF

echo "Compiling Ruby"
env RUBY_CONFIGURE_OPTS="--with-jemalloc --disable-install-doc" RUBY_MAKE_INSTALL_OPTS="DESTDIR=$COMPILE_DEST" RUBY_PREFIX_PATH="/usr" ruby-build 2.3.7-package $COMPILE_DEST -v

echo "Building debian package"
dpkg-deb --build $COMPILE_DEST

echo "Publishing package to Gemfury"
PACKAGE_FILE="$COMPILE_DEST.deb"
curl -F package=@$PACKAGE_FILE https://9ryw1qeUBWiPN7PsYosx@push.fury.io/myfreecomm/
