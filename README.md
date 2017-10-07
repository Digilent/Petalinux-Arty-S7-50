# Arty Z7-20 Petalinux BSP Project

## Built for Petalinux 2017.2

#### Warning: You should only use this repo when it is checked out on a release tag

## BSP Features

This project provides a simple Arty S7-50 Linux platform. For information on using Xilinx SDK to cross-compiling programs, see
the documentation included with the Vivado block diagram associated with this product: https://github.com/Digilent/Arty-S7-50-base-linux
 
## Known Issues

* petalinux-package --boot will fail when trying to insert the fs-boot.elf into the bitstream. See the "Build the petalinux project" 
  section for the correct workaround. 
* The Arty S7 does not have any networking interfaces such as ethernet, which greatly limits its usefulness as a Linux system. The only
  means of communication between a host and the Linux system is via the terminal started over USB UART. To receive and send files over this
  terminal, tools like minicom or sz/rz can be used from the host to transfer the files using the ZMODEM protocol.
* Currently only booting from onboard SPI flash is supported. This means that image.ub must be less than the size of the flash
  partition allocated for storing it. By default, this is 13,631,488 bytes. If image.ub is larger than this, you must disable
  features using petalinux-config -c rootfs and petalinux-config -c kernel to reduce its size.
* Although it is disabled in petalinux-config -c rootfs, dropbear server is still present in rootfs. This causes unnessary size
  and boot delays.
* "INIT: Id "1" respawning too fast: disabled for 5 minutes" will appear every 5 minutes at the terminal. This is likely due to
  something unneccessary in inittab.
* Quad SPI flash is not currently visible as an MTD device in linux, despite being properly configured in device tree. It is accessible from
  u-boot.
* MACHINE_NAME is currently still set to "template". Not sure the ramifications of changing this, but I don't think our boards
  our supported. For now just leave this as is until we have time to explore the effects of changing this value.
* We have experienced issues with petalinux when it is not installed to /opt/pkg/petalinux/. Digilent highly recommends installing petalinux
  to that location on your system.

## Quick-Start Guide

This guide will walk you through some basic steps to get you booted into Linux and rebuild the Petalinux project. After completing it, you should refer
to the Petalinux Reference Guide (UG1144) from Xilinx to learn how to do more useful things with the Petalinux toolset. Also, refer to the Known Issues 
section above for a list of problems you may encounter and work arounds.

This guide assumes you are using Ubuntu 16.04.3 LTS. Digilent highly recommends using Ubuntu 16.04.x LTS, as this is what we are most familiar with, and 
cannot guarantee that we will be able to replicate problems you encounter on other Linux distributions.

### Install the Petalinux tools

Digilent has put together this quick installation guide to make the petalinux installation process more convenient. Note it is only tested on Ubuntu 16.04.3 LTS. 

First install the needed dependencies by opening a terminal and running the following:

```
sudo -s
apt-get install tofrodos gawk xvfb git libncurses5-dev tftpd zlib1g-dev zlib1g-dev:i386  \
                libssl-dev flex bison chrpath socat autoconf libtool texinfo gcc-multilib \
                libsdl1.2-dev libglib2.0-dev screen pax 
reboot
```

Next, install and configure the tftp server (this can be skipped because booting via TFTP isn't supported by the Arty S7-50):

```
sudo -s
apt-get install tftpd-hpa
chmod a+w /var/lib/tftpboot/
reboot
```

Create the petalinux installation directory next:

```
sudo -s
mkdir -p /opt/pkg/petalinux
chown <your_user_name> /opt/pkg/
chgrp <your_user_name> /opt/pkg/
chgrp <your_user_name> /opt/pkg/petalinux/
chown <your_user_name> /opt/pkg/petalinux/
exit
```

Finally, download the petalinux installer from Xilinx and run the following (do not run as root):

```
cd ~/Downloads
./petalinux-v2017.2-final-installer.run /opt/pkg/petalinux
```

Follow the onscreen instructions to complete the installation.

### Source the petalinux tools

Whenever you want to run any petalinux commands, you will need to first start by opening a new terminal and "sourcing" the Petalinux environment settings:

```
source /opt/pkg/petalinux/settings.sh
```

### Generate project

If you have obtained the project source directly from github, then you should simply _cd_ into the Petalinux project directory. If you have downloaded the 
.bsp, then you must first run the following command to create a new project.

```
petalinux-create -t project -s <path to .bsp file>
```

This will create a new petalinux project in your current working directory, which you should then _cd_ into.

### Build the petalinux project

Run the following commands to build the petalinux project with the default options:

```
petalinux-config --oldconfig
petalinux-build
```
The next step is to create the .mcs file to program the onboard flash, however petalinux-package is currently failing to combine the bitstream with the
first-stage bootloader. This is likely due to a bug with Spartan-7 support that will be fixed in a future release of petalinux. For now,
Xilinx SDK (2017.2.1 or newer) must be used to combine the bitstream with the fs-boot.elf file found in _images/linux_, and then manually provided to the
petalinux-package command. This repo includes a download.bit that has already been generated for this project and includes the fs-boot.elf.
As long as you don't modify the first-stage bootloader or the block diagram, you can simply run the following command to package your
newly built system into a flash image named boot.mcs in the _images/linux_ directory:

```
petalinux-package --boot --force --fpga download.bit --fsbl none --u-boot --kernel --flash-size 16 --flash-intf SPIx4
```

### Boot the newly built files from Flash

To boot your linux system you should use the Program Flash feature of Xilinx SDK to program the boot.mcs file into the Arty S7-50 onboard
Flash. For instructions on doing this, see the documentation included with the Vivado block diagram: https://github.com/Digilent/Arty-S7-50-base-linux . 
 
### Prepare for release:

This section is only relevant for those who wish to upstream their work or version control their own project correctly on Github.

First, remove the TMPDIR setting from project-spec/configs/config.

```
cd ..
git status # to double-check
git add .
git commit
git push
```


