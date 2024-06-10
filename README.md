# Mainframe Zork (Dungeon) for UniPlus+ (System V) Unix on the Apple Lisa
This is a port of Mainframe Zork (or, Dungeon, as it would also be called) for the Apple Lisa running UniPlus (System V) Unix. The original Zork was written in MDL (pronounced “Muddle”) on a PDP-10; MDL was a descendant of LISP and, effectively, a cousin of what most of Infocom’s catalogue would be written in: ZIL – the Zork Implementation Language. Eventually, DEC engineer Bob Supnik would port the MDL source code to FORTRAN IV; this codebase would then go on to be the basis of a port to FORTRAN 77 for the PDP-11 which, in turn and by way of the f2c (FORTRAN to C) conversion utility, would serve as the cornerstone upon which this effort is based – C. The C port is a bit of a relic at this point, for two reasons among many: first, it is written in K&R C and, second, there’s a tremendous amount of mangling done by the f2c utility. Crack open the C source and you’ll find a LOT of latent FORTRAN formatting and syntax, such as line numbers and GOTO statements. Yeah. (As an aside, I had no idea C supported such things at any point in its history.) The K&R C is a challenge on its own, though. Depending on the compiler and OS, things like constants may or may not be supported, for instance, or certain libraries may not be provided (or even exist). Nonetheless, this effort proved successful, and we now have a release of Mainframe Zork for the Apple Lisa (by way of Unix, but, still…).

## Changes
Thankfully, only a few changes were required to get this up and running; the greatest effort came from just getting Unix to cooperate (this project started with Xenix several weeks prior…) with getting the files moved over to my Lisa.
The greatest number of changes were made in the supp.c file, as it contains most of the system-specific parts of the code. The included libraries, for instance, needed to be updated to reflect UniPlus’ available C libraries and their correct locations. Additionally, Zork supports multiple methods for working with terminals in supp.c; UniPlus’ termcaps and curses support isn’t documented as well as would be preferred, so we effectively force it to run in VT100 (80x24) mode. This required updating the more_output function in supp.c to support pausing every 24 lines (this functionality was present but disabled) and renaming a function called “more_input” to something else (in our case, reset_coutput). This was required due to an error during compiling that would seem to imply that another function with that name already existed somewhere else (the error in question being “Multiply defined symbol”). I was unable to locate this function as having been declared anywhere else in the Zork source, and I have yet to comb through the rest of UniPlus; since changing the function name fixed the issue, I’m not too concerned. References to the function needed to be updated in a few other files where it was called and, once that was taken care of, the lion’s share of the work was done. Except… there was one other thing.
I needed a way to get binary data over the serial connection from my desktop to my Lisa, so I figured I’d go with the old standby solution that’s literally been around for 40+ years – uuencode/uudecode. To my surprise, they were not included in the UniPlus distribution. This meant that I had two options, mess around with trying to move data around over floppy disks/images, or, write an implementation of uuencode/uudecode for UniPlus. I opted for the latter and the source can be found here: [uuencode/uudecode](https://github.com/warmech/lisa-uniplus-uuencode). It’s not pretty (or good – it’s barebones and probably poorly put together and C is not my strong suit in the slightest) but it does do the job and is compatible with modern implementations of the two programs as well! Either way, this allowed the game’s single binary data file to be moved over to the Lisa.

## Files

### Source Files
The codebase has 33 C source files, three (3) header files, a single database file, and a makefile. All of these may be found in the /src directory.

### Tar Files
The /tar directory contains four files that can be extracted on the Lisa: 
-	zork_c.tar – the C source files for Zork
-	zork_d.tar - the game's database file
-	zork_h.tar - the C header files for Zork
-	zork_m.tar - the makefile for compiling Zork

### Binaries
The /bin directory contains the Zork executable and it’s required database file, dtextc.dat. Not much can be done with these outside of UniPlus, but they are included here for research purposes.

### Disk Images
The /dsk directory contains three disk images:
- zork_source_files.image - the C source files for Zork, along with a readme and build environment setup script
- zork_additional_data.image - the C header files for Zork, along with the game's data file and makefile
- zork_bin_install.image - the game executable and data file, along with a readme and installer script

The Source Files image contains three files, the C source code tar file, a setup script to automate the process of getting the data ready to compile, and a readme. Copy the setup.sh file to the hard disk and run with ```./setup.sh```; the script will handle extracting the source files and managing floppy disks without you having to do anything but swap disks when prompted.

The Additional Data disk contains tar files that contain the C headers that Zork uses, the game data file, and the makefile. While you can manually manipulate these files, the setup.sh script will take care of that for you.

Lastly, the Binary Install disk contains the Zork executable and game data file, as well as a readme and installer script that copies the first two files into their correct locations on the hard disk. Run ```./install.sh``` on the disk to install the game.

## Building
To build from the source files, either copy the necessary files across a serial connection to the Lisa (uudecode will be required to decode dtextc.dat from its text form if this is done) or copy the setup script off the source files disk to the hard disk and run it using ```./setup.sh```. The prior method is beyond the scope of this document, so the latter method is highly recommended if you are looking to build Zork from scratch.

Once the source files (all *.c and *.h files), the game data file, and the makefile have all been put in place (/tmp/zork is used by the setup script), cd into the directory they were copied to and run ```make``` to start the compilation process. You will eventually receive a warning when compiling dsub.c that a particular line is unreachable; this warning can be ignored.

## Installing from Built Source
Once the process completes, there should now be a “zork” file present in the source code directory. The installation process is completed by running ```make install``` to copy the resultant executable to /usr/games and the game data file to /usr/games/lib. The game can then be run directly by running ```/usr/games/zork``` from anywhere on the system.

## Installing from Disk Image
To install a pre-built version of the game, insert the Binary Install floppy disk/disk image (if using a FloppyEmu) and run the install script with ```./install.sh``` and wait for the copy process to conclude. The game can then be run directly by running ```/usr/games/zork``` from anywhere on the system.

## Playing
To play the game, run ```/usr/games/zork``` from anywhere on the system and the Zork program will launch. This version has been compiled with the debugger flag set; to run the debugger when playing the game, enter the command ```gdt``` and hit Enter. To exit the debugger, type ```EX``` and hit Enter.
