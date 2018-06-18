
# Set-Up –- File Server

## NFS
NFS is used to make home directories available on all machines.

Firstly, install the server. For Ubuntu, follow the Quick-Start steps in https://help.ubuntu.com/community/SettingUpNFSHowTo

	sudo apt install nfs-kernel-server
	sudo mkdir /home/teams
	sudo mkdir -p /export/users
	sudo chmod 777 /export
	sudo chmod 777 /export/users
	sudo mount --bind /home/teams /export/users
	sudoedit /etc/fstab
		/home/teams    /export/users   none    bind  0  0
	sudoedit /etc/exports
		/export       10.8.3.0/24(rw,fsid=0,insecure,no_subtree_check,async)
		/export/users 10.8.3.0/24(rw,nohide,insecure,no_subtree_check,async)

First get everything running without authentication and the portmap steps if you choose to apply these.

## NIS / Manually
NIS is used to make user accounts available on all machines. You can also make accounts by hand.

	sudo mkdir /home/teams
	sudo useradd FCPortugal3d -m -b /home/teams
	sudo useradd BahiaRT -m -b /home/teams
	sudo useradd ITAndroids -m -b /home/teams
	sudo useradd KgpKubs -m -b /home/teams
	sudo useradd magmaOffenburg -m -b /home/teams
	sudo useradd Miracle3D -m -b /home/teams
	sudo useradd UTAustinVilla -m -b /home/teams

If you want to use NIS, then, again install the server, then the clients. For this, on Ubuntu follow the instructions on https://help.ubuntu.com/community/SettingUpNISHowTo . You can initially skip all steps that involve portmap.

## Closing Home Directories
When agents write a lot of logging to a team’s home directory they will slow down NFS and the network significantly. To prevent this, you should disable writing before each round. First, set up log directories for each team on the client machines by running this script (this and the 2 scripts below assume the team home directories are under /home/teams):

	#!/bin/bash
	cd /home/teams
	for t in *
	do
	  sudo ln -s /teamlogs/$t $t/log
	done

Now when teams log to this directory, the output is written to the current machine, not to NFS.

To close down the home directories before each round, use the following script:

	#!/bin/bash
	cd /home/teams
	for t in *
	do
	    chmod a-w $t -R
	    chmod u+w $t/log -R
	done

Finally, to open the home directories again when the round is finished you can use the following:

	#!/bin/bash
	cd /home/teams
	for t in *
	do
	    chmod u+w $t -R
	done

Dont worry about errors on removing permissions from the log file.

## Performance mode

	sudo apt install cpufrequtils
	sudoedit /etc/init.d/cpufrequtils
		GOVERNOR="performance"

