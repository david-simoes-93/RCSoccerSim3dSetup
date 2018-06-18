# RoboCup 3D Soccer Simulation

# Organizing Committee Guide

## Introduction

This document aims to provide a complete guide to the Organizing Committee (OC) of a RoboCup 3D Soccer Simulation competition. It provides a platform to transfer knowledge and experience gained from past competitions. Examples of content it should have include, but are not limited to: hardware requirements; installation instructions; scheduling guides; tips on rules; experience of extraordinary situations and rulings.

## Hardware Machines

To run a competition,  the following list of machines is the bare minimum that  is required:

- 1x Server machine; as many cores as possible (simspark using ODE-TBB can in theory use 22 cores in parallel, but 8 (or 4 hyperthreaded) cores usually suffices).
- 2x Client/Agent machines; again as many cores as possible, as each will run 11 agents.
- 1x Monitor, keyboard, mouse.
- Decent size HDs for all machines, e.g. 500GB; for the server machine to store match logfiles, for client machines to store team logfiles.

Furthermore, the following is highly advised to have things run more smoothly:
	
- 1x Visualization machine; mid-range GPU. If not available, the server machine should be equipped with such a GPU and used as the visualization machine.
- Monitor, keyboard and mouse for each available machine.
- 1x File server machine, to host NFS and NIS if used.

The above cluster of machines can be repeated to run multiple matches in parallel. With ~20+ teams at least 2 of these clusters is needed to be able to run all matches. An extra cluster for teams to test on is helpful as well.


## Network

To build a network, a Gigabit switch + NICs and CAT6 cables must be used.
It must be possible to physically disconnect the competition network from the internet/event LAN, which must be done during matches to restrict interference. If using multiple clusters, having the ability to separate them physically may help stability, though when using NFS this means you need a mirroring file server for each cluster.
The competition machines should have static IPs.



# Set-Up -- SERVER

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


# RCSServer3D
Main installation instructions are found at http://simspark.sourceforge.net/wiki/index.php/Installation_on_Linux#Requirement

The following are a reproduction of these, with some additions specific to running a competition. This should be done on all server machines. Install dependency packages. On Ubuntu:

	sudo apt install build-essential subversion git cmake libfreetype6-dev libsdl1.2-dev ruby ruby-dev libdevil-dev libboost-dev libboost-thread-dev libboost-regex-dev libboost-system-dev qt4-default

Install multi-threaded ODE:

	sudo apt install autogen automake libtool libtbb-dev
	git clone https://github.com/sgvandijk/ode-tbb.git
	cd ode-tbb
	./autogen.sh
	./configure --enable-shared --disable-demos --enable-double-precision --disable-asserts --enable-malloc
	make -j8
	sudo make install

Install simulator. Download the latest versions of simspark and rcssserver3d from https://gitlab.com/robocup-sim/SimSpark/wikis/Installation-on-Linux :

	git clone https://gitlab.com/robocup-sim/SimSpark
	cd SimSpark/spark
	mkdir build
	cd build
	cmake ..
	make -j8
	sudo make install
	sudo ldconfig
	cd ../../rcssserver3d
	mkdir build
	cd build
	cmake ..
	make -j8
	sudo make install
	sudo ldconfig
	
## Proxy

To use the proxy, the server must run in sync mode. To do this

	sudoedit /usr/local/share/simspark/spark.rb
		$agentSyncMode = true
		$monitorLoggerStep = 0.04
	rm ~/.simspark/spark.rb

## Performance mode

	sudo apt install cpufrequtils
	sudoedit /etc/init.d/cpufrequtils
		GOVERNOR="performance"


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



# Set-Up -– Viewers

## Configuration

Enable ssh passwordless login

	ssh-keygen

For all hostnames (clients and servers),  run:

	ssh-copy-id root@hostname
	ssh-copy-id hostname

where you select the right hostname.

## RoboViz

RoboViz is the preferred visualizer, install it on the visualization machine(s). Full installation and usage instructions are on its homepage:

	sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update
	sudo apt-get install oracle-java8-installer
	git clone https://github.com/magmaOffenburg/RoboViz/
	cd RoboViz/scripts
	./build-linux64.sh
	mv ../bin/linux-amd64 ../../Roboviz
	cd ../../Roboviz
	nano config.txt
		Bloom         : false
		Server Hosts  : 10.8.3.51

## League Manager

Obtain a copy of the latest League Manager version; the version used for the 2013 world championship can be found at https://gitlab.com/robocup-sim/rclm2

To install, do the following on each machine you will start the matches from (i.e once for each cluster):
Download and extract archive.

	git clone https://gitlab.com/robocup-sim/rclm2

Edit the file types/3Dspark/config as appropriate for the current cluster: set the right NET_PREFIX, set the right IP ending for the SERVER, CLIENT1 and CLIENT2 variables, turn off the automatic kickoff and quit if you don’t want them. The default values for other variables should be sufficient.
	
	cd rclm2
	edit share/rclm2/types/3Dspark/config
		NET_PREFIX=10.8.3
		SERVER=${NET_PREFIX}.51
		CLIENT1=root@${NET_PREFIX}.52
		CLIENT2=root@${NET_PREFIX}.54

Make and install:

	sudo apt-get install dh-autoreconf libboost-dev ruby
	./bootstrap
	./configure && make && sudo make install

Now, for each group to run, do the following:

	rclm2 groupname
	cd groupname
	./script/init 3Dspark
	edit teams
		[ enter list of teams in this group, by their username, one on each line; save & exit]
		FCPortugal3d
		BahiaRT
		magmaOffenburg
		KgpKubs
		UTAustinVilla
		ITAndroids
		Miracle3D
	./script/schedule/init teams

To start the group, start RoboViz, and run ./script/start in the group directory. Some pointers for during running the group:
- After each half, the simulator must be stopped. To do so, type ‘end’ and press enter in the terminal where the league manager is running. Alternatively, while editing types/3Dspark/config, set USED_MONITOR to ‘internal’, or empty; this way the league manager continues automatically when the server is killed (e.g. by pressing shift+X in RoboViz).
- If the league manager asks to run complementary match, choose ‘y’ (yes) if the match got interrupted erroneously (e.g server crash), or to start a second half.
- To change the schedule by hand (e.g. to rerun a match, or reorder matches), edit the file var/schedule in the round directory.
- Logs are compressed and stored automatically in the ‘archives’ directory in the group folder.

## Performance mode

	sudo apt install cpufrequtils
	sudoedit /etc/init.d/cpufrequtils
		GOVERNOR="performance"


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
