
# Monitor Set-Up

## Configuration

Start with basics.

	sudo apt update

If you defined useful hostnames on each machine, list them and their IP addresses in `/etc/hosts`. Enable ssh passwordless login.

	ssh-keygen

For all hostnames (clients and servers), run:

	ssh-copy-id root@hostname
	ssh-copy-id hostname

where you select the right hostname.

## RoboViz

RoboViz is the preferred visualizer, install it on the visualization machine(s). Full installation and usage instructions are on its [homepage](https://github.com/magmaOffenburg/RoboViz):

	sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update
	sudo apt-get install oracle-java8-installer
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

	sudo apt-get install dh-autoreconf libboost-dev ruby
	./bootstrap
	./configure && make && sudo make install

## Performance mode

To ensure the machine is running at peak performance, enable performance mode.

	sudo apt install cpufrequtils
	sudoedit /etc/init.d/cpufrequtils
		GOVERNOR="performance"

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