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

