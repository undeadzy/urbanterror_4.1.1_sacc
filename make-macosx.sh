#!/bin/sh
CC=gcc-4.0
APPBUNDLE=ioquake3.app
BINARY=ioquake3.x86_64
DEDBIN=ioq3ded.x86_64
PKGINFO=APPLIOQ3
ICNS=misc/quake3.icns
DESTDIR=build/release-darwin-x86_64
BASEDIR=baseq3
MPACKDIR=missionpack

BIN_OBJ="
	build/release-darwin-x86_64/ioquake3.x86_64
"
BIN_DEDOBJ="
	build/release-darwin-x86_64/ioq3ded.x86_64
"
BASE_OBJ="
	build/release-darwin-x86_64/$BASEDIR/cgamex86_64.dylib
	build/release-darwin-x86_64/$BASEDIR/uix86_64.dylib
	build/release-darwin-x86_64/$BASEDIR/qagamex86_64.dylib
"
MPACK_OBJ="
	build/release-darwin-x86_64/$MPACKDIR/cgamex86_64.dylib
	build/release-darwin-x86_64/$MPACKDIR/uix86_64.dylib
	build/release-darwin-x86_64/$MPACKDIR/qagamex86_64.dylib
"
RENDER_OBJ="
	build/release-darwin-x86_64/renderer_opengl1_smp_x86_64.dylib
	build/release-darwin-x86_64/renderer_opengl1_x86_64.dylib
	build/release-darwin-x86_64/renderer_rend2_smp_x86_64.dylib
	build/release-darwin-x86_64/renderer_rend2_x86_64.dylib
"

cd `dirname $0`
if [ ! -f Makefile ]; then
	echo "This script must be run from the ioquake3 build directory"
	exit 1
fi

Q3_VERSION=`grep '^VERSION=' Makefile | sed -e 's/.*=\(.*\)/\1/'`

# We only care if we're >= 10.4, not if we're specifically Tiger.
# "8" is the Darwin major kernel version.
TIGERHOST=`uname -r |perl -w -p -e 's/\A(\d+)\..*\Z/$1/; $_ = (($_ >= 8) ? "1" : "0");'`

# we want to use the oldest available SDK for max compatiblity. However 10.4 and older
# can not build 64bit binaries, making 10.5 the minimum version.   This has been tested 
# with xcode 3.1 (xcode31_2199_developerdvd.dmg).  It contains the 10.5 SDK and a decent
# enough gcc to actually compile ioquake3

unset X86_SDK
unset X86_CFLAGS
unset X86_LDFLAGS
if [ -d /Developer/SDKs/MacOSX10.5.sdk ]; then
	X86_SDK=/Developer/SDKs/MacOSX10.5.sdk
	X86_CFLAGS="-arch x86_64 -isysroot /Developer/SDKs/MacOSX10.5.sdk \
			-DMAC_OS_X_VERSION_MIN_REQUIRED=1050"
	X86_LDFLAGS=" -mmacosx-version-min=10.5"
fi


echo "Building X86 Client/Dedicated Server against \"$X86_SDK\""
sleep 3

if [ ! -d $DESTDIR ]; then
	mkdir -p $DESTDIR
fi

# For parallel make on multicore boxes...
NCPU=`sysctl -n hw.ncpu`


# intel client and server
if [ -d build/release-darwin-x86_64 ]; then
	rm -r build/release-darwin-x86_64
fi
(ARCH=x86_64 CFLAGS=$X86_CFLAGS LDFLAGS=$X86_LDFLAGS make -j$NCPU) || exit 1;

echo "Creating .app bundle $DESTDIR/$APPBUNDLE"
if [ ! -d $DESTDIR/$APPBUNDLE/Contents/MacOS/$BASEDIR ]; then
	mkdir -p $DESTDIR/$APPBUNDLE/Contents/MacOS/$BASEDIR || exit 1;
fi
if [ ! -d $DESTDIR/$APPBUNDLE/Contents/MacOS/$MPACKDIR ]; then
	mkdir -p $DESTDIR/$APPBUNDLE/Contents/MacOS/$MPACKDIR || exit 1;
fi
if [ ! -d $DESTDIR/$APPBUNDLE/Contents/Resources ]; then
	mkdir -p $DESTDIR/$APPBUNDLE/Contents/Resources
fi
cp $ICNS $DESTDIR/$APPBUNDLE/Contents/Resources/ioquake3.icns || exit 1;
echo $PKGINFO > $DESTDIR/$APPBUNDLE/Contents/PkgInfo
echo "
	<?xml version=\"1.0\" encoding=\"UTF-8\"?>
	<!DOCTYPE plist
		PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\"
		\"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
	<plist version=\"1.0\">
	<dict>
		<key>CFBundleDevelopmentRegion</key>
		<string>English</string>
		<key>CFBundleExecutable</key>
		<string>$BINARY</string>
		<key>CFBundleGetInfoString</key>
		<string>ioquake3 $Q3_VERSION</string>
		<key>CFBundleIconFile</key>
		<string>ioquake3.icns</string>
		<key>CFBundleIdentifier</key>
		<string>org.ioquake.ioquake3</string>
		<key>CFBundleInfoDictionaryVersion</key>
		<string>6.0</string>
		<key>CFBundleName</key>
		<string>ioquake3</string>
		<key>CFBundlePackageType</key>
		<string>APPL</string>
		<key>CFBundleShortVersionString</key>
		<string>$Q3_VERSION</string>
		<key>CFBundleSignature</key>
		<string>$PKGINFO</string>
		<key>CFBundleVersion</key>
		<string>$Q3_VERSION</string>
		<key>NSExtensions</key>
		<dict/>
		<key>NSPrincipalClass</key>
		<string>NSApplication</string>
	</dict>
	</plist>
	" > $DESTDIR/$APPBUNDLE/Contents/Info.plist

for i in $BIN_OBJ $BIN_DEDOBJ $RENDER_OBJ
do
        install_name_tool -change "@rpath/SDL.framework/Versions/A/SDL" "@executable_path/../Frameworks/SDL.framework/Versions/A/SDL" $i
done


cp $BIN_OBJ $DESTDIR/$APPBUNDLE/Contents/MacOS/$BINARY
cp $BIN_DEDOBJ $DESTDIR/$APPBUNDLE/Contents/MacOS/$DEDBIN
cp $RENDER_OBJ $DESTDIR/$APPBUNDLE/Contents/MacOS/
cp $BASE_OBJ $DESTDIR/$APPBUNDLE/Contents/MacOS/$BASEDIR/
cp $MPACK_OBJ $DESTDIR/$APPBUNDLE/Contents/MacOS/$MPACKDIR/
cp code/libs/macosx/*.dylib $DESTDIR/$APPBUNDLE/Contents/MacOS/

