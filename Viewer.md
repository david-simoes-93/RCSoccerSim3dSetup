
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
