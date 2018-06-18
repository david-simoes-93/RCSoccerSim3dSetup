
# Set-Up -- CLIENTS

## OS

Choose a recent Linux OS that you are comfortable with, and that you know of that the simulator runs on. Most teams will be familiar with Ubuntu, other popular choice is Fedora.
Choose a 64 bit OS.
Have several installation methods ready, with different versions if unsure, and both on disk and on USB drive in case the machines don’t support one.

## Configuration

During installation, give each machine a useful host name (e.g. server1, agent1, monitor1).
Install required packages on all machines. On Ubuntu:

	sudo apt install openssh-server

The League Manager (see below) uses the root account to log into the different machines. Ubuntu by default disables this account, to enable it give it a password by running:

	sudo passwd root
	sudo passwd -u root

Do this on the server and client machines
List all machine IP address and host names in /etc/hosts and distribute it over all machines.
Set up passwordless SSH. First generate an SSH key on the machine and under the account from which you will run the league manager, usually the visualization machine:

	ssh-keygen

Press <Enter> on all questions to select the default values, and to choose not to set a password. This will generate a private and public key. For convenience, run:

	sudoedit /etc/ssh/sshd_config
		PermitRootLogin yes
	sudo service ssh restart

## NFS

NFS is used to make home directories available on all machines.

https://help.ubuntu.com/community/SettingUpNFSHowTo

Again, follow the Quick-Start steps linked to above.

	sudo apt install nfs-common
	sudo mkdir /home/teams
	sudo mount -t nfs -o proto=tcp,port=2049 10.8.3.51:/users /home/teams
	sudo nano /etc/fstab
		10.8.3.51:/users    /home/teams    nfs    auto,nolock    0    0

The nolock option should not be needed, but could maybe prevent lockups (or maybe not). Other mount options that you may try setting are rsize and wsize to set read and write block size, where larger values may speed up things. Also see for instance:

http://www.centos.org/docs/5/html/Deployment_Guide-en-US/s1-nfs-client-config-options.html

And check ‘man nfs’ to see which defaults are already used. The most important way to get NFS stable however is to prevent any writing, as discussed below.

## NIS / Manually

NIS is used to make user accounts available on all machines. You can also make accounts by hand.

	sudo useradd FCPortugal3d -b /home/teams
	sudo useradd BahiaRT -b /home/teams
	sudo useradd ITAndroids -b /home/teams
	sudo useradd KgpKubs -b /home/teams
	sudo useradd magmaOffenburg -b /home/teams
	sudo useradd Miracle3D -b /home/teams
	sudo useradd UTAustinVilla -b /home/teams	

If you want to use NIS, then, again install the server, then the clients. For this, on Ubuntu follow the instructions on https://help.ubuntu.com/community/SettingUpNISHowTo . You can initially skip all steps that involve portmap.

## Closing Home Directories

When agents write a lot of logging to a team’s home directory they will slow down NFS and the network significantly. To prevent this, you should disable writing before each round. First, set up log directories for each team on the client machines by running this script (this and the 2 scripts below assume the team home directories are under /home/teams):

	#!/bin/bash
	sudo mkdir /teamlogs
	cd /home/teams
	for t in *
	do
	  sudo mkdir /teamlogs/$t
	  sudo chown $t:$t /teamlogs/$t
	done

Now when teams log to this directory, the output is written to the current machine, not to NFS.

## Performance mode

	sudo apt install cpufrequtils
	sudoedit /etc/init.d/cpufrequtils
		GOVERNOR="performance"

## Proxy

Download and extract the rcssserver proxy onto the client machines from:

	sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update
	sudo apt install git oracle-java8-installer
	git clone https://github.com/magmaOffenburg/magmaProxy
	cd magmaProxy
	chmod +x start.sh

Usage instructions are in the included README.txt file. Note that the server must run in sync mode if the proxy is used. Start the proxy on all client machines before running a group.

	./start.sh 10.8.3.51 3100 3100
