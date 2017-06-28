#!/bin/bash

ROOT_DIR="/home/pi/tinyos"
NESC_DIR="$ROOT_DIR/nesc"
TINYOS_DIR="$ROOT_DIR/tinyos-main"

before_reboot(){

	sudo apt-get -y update
	sudo apt-get upgrade
	
	sudo rm /var/lib/apt/lists/lock
	sudo rm /var/cache/apt/archives/lock
	sudo rm /var/lib/dpkg/lock
	sudo dpkg --configure -a

    mkdir $ROOT_DIR && cd $ROOT_DIR

	mkdir nesc && echo "mkdir nesc"
	mkdir tinyos-main && echo "mkdir tinyos-main"
	
	sudo apt-get -y install emacs vim gperf bison flex git autoconf automake libtool && echo "installed"
	#sudo reboot -h now
}

after_reboot(){

	# Install tools for TinyOS
	sudo apt-get -y install build-essential python2.7 python2.7-dev automake avarice avr-libc msp430-libc avrdude binutils-avr binutils-msp430 gcc-avr gcc-msp430 gdb-avr subversion graphviz python-docutils checkinstall

	# Install NesC

    cd $ROOT_DIR
	git clone git://github.com/tinyos/nesc.git && cd $NESC_DIR
	./Bootstrap && echo "boot done"
	./configure && echo "configure done"
	make && echo "make done"
	sudo make install && echo "install done"

	# Install TinyOS
	cd $ROOT_DIR
	git clone git://github.com/tinyos/tinyos-main.git && cd $TINYOS_DIR/tools/
	#sudo dpkg --configure -a
	./Bootstrap && echo "boot done"
	./configure && echo "configure done"
	make && echo "make done"
	sudo make install && echo "install done"
	
	# Compile a program
	printf "Connect your mote to the USB port..."
	sleep 5
	
	motelist
	
	cd ~/tinyos/tinyos-main/apps/Blink
	sudo make telosb
	sudo make telosb install
	
	# Setup Bashrc
	printf "Modify the Bash.Bashrc"
	sudo nano /etc/bash.bashrc
}

if [ -d "$ROOT_DIR" ]; then
	after_reboot
else
	before_reboot
fi
