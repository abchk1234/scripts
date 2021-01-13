#!/bin/bash
# FNA Update Script
# Written by Ethan "flibitijibibo" Lee
# Edited by TheDaftRick
#
# Released under public domain.
# No warranty implied; use at your own risk.
#
# Linux guide:
# Place this file fnaUpdate.sh in your Terraria folder
# Open your Terraria folder in terminal and run these two commands
# chmod +x fnaUpdate.sh
# ./fnaUpdate.sh -autoarch
# Add a Non-Steam game and select Terraria.bin.x86_64 in your Terraria folder
# Use this to run Terraria (Steam will still see you running the regular version of Terraria with all Steam features working)
#
# If you want to run the 32bit version of Terraria then use this script to update FNA to 1707
# https://gist.github.com/TheDaftRick/d5e49ebbfd8f09ddfb66dc29e775ece1
#
# Run this script in the game's executable folder.
# For OSX this will be Game.app/Contents/MacOS/.
#
# This script requires the following programs:
# - git
# - make
# - dmcs, the Mono C# compiler

# Be Smart. Be Safe.
set -e

# Move to script's directory
cd "`dirname "$0"`"

# Get the system architecture
UNAME=`uname`
ARCH=`uname -m`

# Grab native libraries
curl -O fna.flibitijibibo.com/archive/fnalibs.tar.bz2
if [ "$UNAME" == "Darwin" ]; then
	tar xvfj fnalibs.tar.bz2 osx
else
	if [ "$ARCH" == "x86_64" ]; then
		tar xvfj fnalibs.tar.bz2 lib64
	else
		tar xvfj fnalibs.tar.bz2 lib
	fi
fi
rm fnalibs.tar.bz2 # Wouldn't want to waste disk space, would we...

# Download and build latest FNA
if [ -d "FNA" ]; then
	cd FNA
	git pull
	git submodule update
else
	git clone --recursive git://github.com/FNA-XNA/FNA.git
	cd FNA
fi
sed -i 's/IntPtr mem,/byte[] mem,/g' lib/SDL2-CS/src/SDL2.cs
make release
cd ..
cp FNA/bin/Release/* .

# We out.
echo Complete!