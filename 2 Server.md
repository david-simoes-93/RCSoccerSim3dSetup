# Server Set-Up

## Configuration

Start with basics.

	sudo apt update
	sudo apt install openssh-server git -y

The League Manager uses the root account to log into the different machines. Ubuntu by default disables this account, to enable it give it a password by running:

	sudo passwd root
	sudo passwd -u root

Set up passwordless SSH. First generate an SSH key on the machine and under the account from which you will run the league manager, usually the visualization machine:

	ssh-keygen

Press `Return` on all questions to select the default values, and to choose not to set a password. This will generate a private and public key. For convenience, run:

	sudoedit /etc/ssh/sshd_config
		PermitRootLogin yes
	sudo service ssh restart

# RCSServer3D

Main installation instructions are found [here](http://simspark.sourceforge.net/wiki/index.php/Installation_on_Linux#Requirement). The following are a reproduction of these, with some additions specific to running a competition. This should be done on all server machines. Install dependency packages.

	sudo apt install build-essential subversion git cmake libfreetype6-dev libsdl1.2-dev ruby ruby-dev libdevil-dev libboost-dev libboost-thread-dev libboost-regex-dev libboost-system-dev qt4-default -y

Install multi-threaded ODE:

	sudo apt install autogen automake libtool libtbb-dev -y
	git clone https://github.com/sgvandijk/ode-tbb.git
	cd ode-tbb
	./autogen.sh
	./configure --enable-shared --disable-demos --enable-double-precision --disable-asserts --enable-malloc
	make -j8
	sudo make install

Install simulator. Download the latest versions of simspark and rcssserver3d from [here](https://gitlab.com/robocup-sim/SimSpark/wikis/Installation-on-Linux):

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

To use the proxy, the server must run in `sync` mode. Also, change the logging frequency for beautiful replays.

	sudoedit /usr/local/share/simspark/spark.rb
		$agentSyncMode = true
		$monitorLoggerStep = 0.04
	rm -f ~/.simspark/spark.rb

## Performance mode

To ensure the machine is running at peak performance, enable performance mode. For an 8-core machine, this did the trick:

    for i in {0..7}; do echo performance > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor; done

This does not seem to work:

	sudo apt install cpufrequtils -y
	sudoedit /etc/init.d/cpufrequtils
		GOVERNOR="performance"

We're not sure how to make this work upon reboot.

