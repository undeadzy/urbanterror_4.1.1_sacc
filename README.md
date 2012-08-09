undeadzy's version of ioUrbanTerror
===================================

This based on ioUrbanTerror with the following differences.  This version is
focused on keeping a minimal set of changes in order to be able to verify it
easier.

NOTE: This now includes the basepakheader.h since FS' latest release also
has it.

You may want to change the Makefile manually to add 'march=native' instead
of 'march=i586' etc.  The ioquake3 devs didn't make it easy to override that
in Makefile.local so you have to manually change it.  GCC detects the proper
architecture with 'native'.  This may add optimizations that aren't available
in i586 at the expense of depending on newer CPU features that others may
not have.

Changes from ioUrT:
-------------------

* Updated SCR_DrawStringExt calls to use the new API
* Changed the functionality of autodownload.
  Rather than any key besides ESC being acceptance, it now requires F1 or it
  doesn't download.  I think this is a safer default and F1 maps to vote yes
  so players should be used to it.
* Changed a curl error message to indicate that the user disabled curl so
  the file cannot be downloaded rather than the generic "unknown error"
* Any functions added to ioUrT that are only used in one file are now static
* Use braces rather than for(i=0; i<1; i++)
* Check the length of the mapname before memmove'ing it to downloadList
  + 'mapname' is currently less than downloadList, but may change in the future
* Does not disable some of the verbose output such as what's
  on the pure list.  This is only cosmetic.
* This uses a different implementation of the unfortunately
  named Q_strnchr and Q_strnrchr() functions
* Whitespace clean thanks to git apply --whitespace=error-all
* ioUrT disables Mac OSX acceleration but ioquake3 enables it.
  - Recently re-enabled
* alt-tab minimize is enabled using a different cvar
  - Calls "/minimize" since later ioquake3 verisons have support
  - Named cl_altTabMinimize

Additions:
----------

* Uses a Makefile.local
  + Defines BUILD_STANDALONE in Makefile.local
* Added LEGACY_PROTOCOL=1 since UrT 4.1.1 is based off of old ioquake3 code
  - Without this change, you would need to play on servers running the newer
    protocol too.

Extensions:
-----------

By default, only the base UrT 4.1.1 functionality ported to the latest
ioquake3 are always included.  These are all extensions that can be enabled
in Makefile.local

* Fix +vstr bug by using mitsubishi's fix from his build
* Added OpenArena's handling of the console.
  - Unlike the OA code, this directly edits finalFrac
  - Shift+` means 1/4 of the screen
  - ` means 1/2 of the screen (default)
  - Alt+` means the entire screen
* Updated the MAX_CMD_BUFFER to 128KiB to match OA and recent ioUrT clients
* Updated MAX_CVARS to 2048
* Includes Rambetter's client message buffer exploit fix
* Use a short record message rather than the full demo name.
  - This was based on Mitsubishi's client

Omissions:
----------

* Doesn't contain anything OS specific
  + None of the MSVC build files were updated
  + Handling of where Windows looks for files/saves demos is ioq3 default now
* No branding (i.e. ioq3 -> iourt) on the binaries so the Makefile diff is much
  smaller and easier to maintain
  - Small changes in the q_shared.h which is designed for standalone.
  - Some of the branding is being moved back.  I'm only enabling it in the
    Makefile.local.
* Doesn't define DLF_BSPNAME_ONLY because it is never used
* Doesn't use cl_master because it is handled upstream differently now
* Doesn't change NET_Sleep because this is handled differently now
* Anything that was cherry picked from a later SVN version that is now
  already present (or implemented differently now).

Still broken in UrT:
--------------------

* ioUrT disables s_useOpenAL by default but ioquake3 enables it.
  - When I enable OpenAL, I'm missing a lot of sounds including the flag
    taken sound.

Note: ioUrbanTerror was based on SVN 1142 in the zip.  However, it has
changes that are identical to later upstream changes.  Either they
were integrated after ioUrT was released, or ioUrT cherry picked changes.

Note: I modified the makefile so it checks for the remote branch version
first.  It will now pick up the correct upstream SVN version.


Original files are from here:
http://ftp.snt.utwente.nl/pub/games/urbanterror/iourbanterror/source/complete/ioUrbanTerrorSource_2007_12_20.zip

    $ sha512sum ioUrbanTerrorSource_2007_12_20.zip
    7c90fff834a971cd3379a1ba68876cdef42232b90feada069fb2d9103e47c2502e178960454f4c9194f646ced263ba60eea1a89298ae00f6d91748349ceb05a8  ioUrbanTerrorSource_2007_12_20.zip
