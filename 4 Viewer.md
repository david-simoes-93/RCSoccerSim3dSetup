
# Monitor Set-Up

## Configuration

Start with basics.

	sudo apt update
	sudo apt install git -y
	git clone https://github.com/bluemoon93/RCSoccerSim3dSetup
	chmod +x RCSoccerSim3dSetup/scripts/*.sh 

If you defined useful hostnames on each machine, list them and their IP addresses in `/etc/hosts`. Enable ssh passwordless login.

	ssh-keygen

For all hostnames (clients and servers), run:

	ssh-copy-id root@hostname
	ssh-copy-id hostname

where you select the right hostname.

## RoboViz

RoboViz is the preferred visualizer, install it on the visualization machine(s). Full installation and usage instructions are on its [homepage](https://github.com/magmaOffenburg/RoboViz):

	sudo add-apt-repository ppa:openjdk-r/ppa -y
	sudo apt update
	sudo apt install openjdk-8-jdk -y
	git clone https://github.com/magmaOffenburg/RoboViz/
	cd RoboViz/scripts
	./build-linux64.sh
	mv ../bin/linux-amd64 ../../Roboviz
	cd ../../Roboviz
	nano config.txt
		Server Hosts         : 10.8.3.51
		Field Overlay        : true
		Number of Players    : true
		Player IDs           : true

If necessary, turn off graphical options for better speed.

	nano config.txt
		Bloom                : false
		Phong                : false
		Shadows              : false
		Soft Shadows         : false


## League Manager

Obtain a copy of the latest [League Manager](https://gitlab.com/robocup-sim/rclm2). Edit the file `types/3Dspark/config` as appropriate for the current cluster: set the right `NET_PREFIX`, set the right IP ending for the `SERVER`, `CLIENT1` and `CLIENT2` variables, turn off the automatic kickoff and quit if you don’t want them. The default values for other variables should be sufficient.

	git clone https://gitlab.com/robocup-sim/rclm2
	cd rclm2
	edit share/rclm2/types/3Dspark/config
		NET_PREFIX=10.8.3
		SERVER=${NET_PREFIX}.51
		CLIENT1=root@${NET_PREFIX}.52
		CLIENT2=root@${NET_PREFIX}.54

Make and install:

	sudo apt install dh-autoreconf libboost-dev ruby -y
	./bootstrap
	./configure
	make -j8
	sudo make install

## Performance mode

To ensure the machine is running at peak performance, enable performance mode. For an 8-core machine, this did the trick:

    for i in {0..7}; do echo performance > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor; done

This does not seem to work:

	sudo apt install cpufrequtils -y
	sudoedit /etc/init.d/cpufrequtils
		GOVERNOR="performance"

We're not sure how to make this work upon reboot.

## Looks

Go to `System Settings` > `Brightness & Lock` and disable the `Dim screen` and `Turn screen off` options.

Go to `System Settings` > `Appearance` > `Behavior` and enable the Launcher `Auto-Hide` option.

If necessary, adjust the resolution of the Roboviz screen, with `System Settings` > `Displays` and changing resolutions as required (1920 by 1080 seems to work well).

## GPU

Remember to install GPU drivers. When Roboviz starts, you can read the `-Renderer` line to see what it is using to render. For NVidia drivers, go to `System Settings` > `Software & Updates` > `Ubuntu Software` > `Download from: Main Server` and close. Reload the differences when asked. Then, `System Settings` > `Software & Updates` > `Additional Drivers` and enable the proprietary NVidia drivers.

## Preparing Rounds

Now, to test each team, do the following (this example uses FCPortugal3d):

	rclm2 test_round
	cd test_round
	./script/init 3Dspark
	edit teams
		FCPortugal3d
		TestTeam
	./script/schedule/init teams

For actual rounds, in the `teams` file, write the round's participating team usernames, one per line.
