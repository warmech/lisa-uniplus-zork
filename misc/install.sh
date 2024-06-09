#!/bin/sh

# Check if the directory /usr/games exists
if [ -d /usr/games ]; then
    echo "Directory /usr/games already exists. Skipping creation."
else
    # Create the directory /usr/games
    mkdir /usr/games
    if [ $? -eq 0 ]; then
        echo "Directory /usr/games has been created. Zork executable will be copied here."
    else
        echo "Error: Unable to create the directory /usr/games. Halting execution."
        exit 1
    fi
fi

# Check if the directory /usr/games/lib exists
if [ -d /usr/games/lib ]; then
    echo "Directory /usr/games/lib already exists. Skipping creation."
else
    # Create the directory /usr/games/lib
    mkdir /usr/games/lib
    if [ $? -eq 0 ]; then
        echo "Directory /usr/games/lib has been created. Zork data file will be copied here."
    else
        echo "Error: Unable to create the directory /usr/games/lib. Halting execution."
        exit 1
    fi
fi

# Required blocks
required_blocks=550

# Check if there are at least 550 blocks free on /
df_output=`df -f /`
free_blocks=`echo "$df_output" | grep '^/' | awk '{print $4}'`

if [ "$free_blocks" -ge "$required_blocks" ]; then
    echo "Sufficient free blocks available: $free_blocks blocks."
else
    echo "Error: Not enough free blocks. Only $free_blocks blocks available, "
	echo "but $required_blocks blocks are required. Halting execution."
    exit 1
fi

# Install Zork executable
if [ -f /t/zork ]; then
    cp /t/zork /usr/games/
    if [ $? -eq 0 ]; then
        echo "Zork executable successfully copied to /usr/games."
    else
        echo "Error: Unable to copy Zork executable to /usr/games. Halting execution."
        exit 1
    fi
else
    echo "Error: Zork executable not found on the floppy disk."
    exit 1
fi

# Install Zork data file
if [ -f /t/dtextc.dat ]; then
    cp /t/dtextc.dat /usr/games/lib/
    if [ $? -eq 0 ]; then
        echo "Zork data file successfully copied to /usr/games/lib."
    else
        echo "Error: Unable to copy Zork data file to /usr/games/lib. Halting execution."
        exit 1
    fi
else
    echo "Error: Zork data file not found on the floppy disk."
    exit 1
fi

echo "Zork installed successfully. Run with: /usr/games/zork"