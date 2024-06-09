#!/bin/sh

# Check if the directory /tmp/zork exists
if [ -d /tmp/zork ]; then
    echo "Directory /tmp/zork already exists. Skipping creation."
else
    # Create the directory /tmp/zork
    mkdir /tmp/zork
    if [ $? -eq 0 ]; then
        echo "Directory /tmp/zork has been created. Zork source files will be copied here."
    else
        echo "Error: Unable to create the directory /tmp/zork. Halting execution."
        exit 1
    fi
fi

# Required blocks
required_blocks=1600

# Check if there are at least 1600 blocks free on /
df_output=`df -f /`
free_blocks=`echo "$df_output" | grep '^/' | awk '{print $4}'`

if [ "$free_blocks" -ge "$required_blocks" ]; then
    echo "Sufficient free blocks available: $free_blocks blocks."
else
    echo "Error: Not enough free blocks. Only $free_blocks blocks available, "
	echo "but $required_blocks blocks are required. Halting execution."
    exit 1
fi

# Prompt the user to insert the first floppy disk and press enter
echo "Please insert the first floppy disk and press Enter to continue..."
read dummy

# Attempt to mount the floppy disk and suppress output
if mount /dev/s0a /t > /dev/null 2>&1; then
    echo "Floppy disk successfully mounted."
else
    echo "Error: Unable to mount the floppy disk. Halting execution."
    exit 1
fi

# Process zork_c.tar
if [ -f /t/zork_c.tar ]; then
    cp /t/zork_c.tar /tmp/zork/
    if [ $? -eq 0 ]; then
        echo "File zork_c.tar successfully copied to /tmp/zork."
        cd /tmp/zork
        tar xf /tmp/zork/zork_c.tar
        if [ $? -eq 0 ]; then
            echo "File zork_c.tar successfully extracted. Removing C source tarball."
            rm /tmp/zork/zork_c.tar
        else
            echo "Error: Unable to extract zork_c.tar. Halting execution."
            umount /dev/s0a
            eject
            exit 1
        fi
    else
        echo "Error: Unable to copy zork_c.tar to /tmp/zork. Halting execution."
        umount /dev/s0a
        eject
        exit 1
    fi
else
    echo "Error: File zork_c.tar not found on the floppy disk."
    umount /dev/s0a
    eject
    exit 1
fi

# Unmount the floppy disk and eject
umount /dev/s0a
eject

# Prompt the user to insert the next floppy disk and press enter
echo "Please insert the Additional Data floppy disk and press Enter to continue..."
read dummy

# Attempt to mount the next floppy disk and suppress output
if mount /dev/s0a /t > /dev/null 2>&1; then
    echo "Additional Data floppy disk successfully mounted."
else
    echo "Error: Unable to mount the Additional Data floppy disk. Halting execution."
    exit 1
fi

# Process zork_d.tar
if [ -f /t/zork_d.tar ]; then
    cp /t/zork_d.tar /tmp/zork/
    if [ $? -eq 0 ]; then
        echo "File zork_d.tar successfully copied to /tmp/zork."
        cd /tmp/zork
        tar xf /tmp/zork/zork_d.tar
        if [ $? -eq 0 ]; then
            echo "File zork_d.tar successfully extracted. Removing database tarball."
            rm /tmp/zork/zork_d.tar
        else
            echo "Error: Unable to extract zork_d.tar. Halting execution."
            umount /dev/s0a
            eject
            exit 1
        fi
    else
        echo "Error: Unable to copy zork_d.tar to /tmp/zork. Halting execution."
        umount /dev/s0a
        eject
        exit 1
    fi
else
    echo "File zork_d.tar not found on the floppy disk."
fi

# Process zork_h.tar
if [ -f /t/zork_h.tar ]; then
    cp /t/zork_h.tar /tmp/zork/
    if [ $? -eq 0 ]; then
        echo "File zork_h.tar successfully copied to /tmp/zork."
        cd /tmp/zork
        tar xf /tmp/zork/zork_h.tar
        if [ $? -eq 0 ]; then
            echo "File zork_h.tar successfully extracted. Removing header files tarball."
            rm /tmp/zork/zork_h.tar
        else
            echo "Error: Unable to extract zork_h.tar. Halting execution."
            umount /dev/s0a
            eject
            exit 1
        fi
    else
        echo "Error: Unable to copy zork_h.tar to /tmp/zork. Halting execution."
        umount /dev/s0a
        eject
        exit 1
    fi
else
    echo "File zork_h.tar not found on the floppy disk."
fi

# Process zork_m.tar
if [ -f /t/zork_m.tar ]; then
    cp /t/zork_m.tar /tmp/zork/
    if [ $? -eq 0 ]; then
        echo "File zork_m.tar successfully copied to /tmp/zork."
        cd /tmp/zork
        tar xf /tmp/zork/zork_m.tar
        if [ $? -eq 0 ]; then
            echo "File zork_m.tar successfully extracted. Removing makefile tarball."
            rm /tmp/zork/zork_m.tar
        else
            echo "Error: Unable to extract zork_m.tar. Halting execution."
            umount /dev/s0a
            eject
            exit 1
        fi
    else
        echo "Error: Unable to copy zork_m.tar to /tmp/zork. Halting execution."
        umount /dev/s0a
        eject
        exit 1
    fi
else
    echo "File zork_m.tar not found on the floppy disk."
fi

# Unmount the floppy disk and eject
umount /dev/s0a
eject

echo "Source and data files moved into /tmp/zork."
echo "Run 'make' from /tmp/zork to compile Zork."
echo "Run 'make install' from /tmp/zork to install Zork"
echo "Run 'make clean' from /tmp/zork to remove object files."