Building on Cygwin
==================

Here is how you can build on Windows 7 64bit using the 32bit build. 
Building for 64bit is easy for the client/engine but you have to track
down/compile SDL, libcurl and openal on your own.  With 32bit, you can reuse
the installer's copy.

These instructions work for a normal user although you will be prompted for an
admin password at parts.

Get Cygwin
----------

Get cygwin here (latest is 1.7.9-1): http://cygwin.com/setup.exe

Use the recommended settings (C:/cygwin, all users) and select a close mirror.

Install Packages
----------------

In the package selection area, select these in addition to the ones that cygwin
has on by default.  This is close to the bare minimum needed:

    Devel -> make

    # For 32bit builds
    Devel -> mingw64-i686-binutils
    Devel -> mingw64-i686-gcc-core
    Devel -> mingw64-i686-headers
    Devel -> mingw64-i686-runtime

    # For 64bit builds
    Devel -> mingw64-x86_64-binutils
    Devel -> mingw64-x86_64-gcc-core
    Devel -> mingw64-x86_64-headers
    Devel -> mingw64-x86_64-runtime

    Devel -> subversion

Before you leave, you may want to install an editor.  Nano is easy to use but
the traditional choices are vim or emacs.  It's possible to edit the files with
Windows tools but less convenient without a little setup.

Click next and accept the recommendations.  They are needed for the packages
that you selected above.

This will download and install cygwin.  It has many of the base utilities
including bash, sed, awk, etc.  Using the above is enough to build ioquake3 as
of r2214.

Build ioquake3
--------------

As far as the actual build, it's simple too:

    $ svn co svn://svn.icculus.org/quake3/trunk ioquake3
    $ cd ioquake3
    $ sh cross-make-mingw.sh   # after it is changed with the patch in bug 5405


Then when that builds the exe and DLL in the build/ directory, you have
everything that you need.

Run ioquake3
------------

Copy baseq3 from a quake3 installation to a new directory say C:/games/quake3
Install the ioquake3 engine
(http://ioquake3.org/files/1.36/installer/ioquake3-1.36-3.1.x86.exe) into a
related directory, C:/games/quake3/vanilla

The ioquake3 1.36 installer includes the necessary DLLs that the runtime needs:
SDL, libcurl and openal.

    $ cd /cygdrive/c/games/quake3
    $ cp vanilla/*.dll .

Now you are ready to run it.  For best results, I would use non-fullscreen mode
so if there is an error it is easier to see.

    ./ioquake3 +set r_fullscreen 0

