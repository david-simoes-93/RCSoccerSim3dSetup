# Running Rounds

Define useful hostnames on each machine by listing them and their IP addresses in `/etc/hosts`. These are optional, just a commodity for easy access. I usually separate machines by clusters `cl1` and `cl2`, when multiple ones are available.

    10.8.3.51 cl1-server
    10.8.3.52 cl1-client1
    10.8.3.54 cl1-client2
    10.8.3.53 cl1-monitor
    10.8.3.51 cl1-nfs

## Preparing Rounds

Now, to test each team, do the following (this example uses FCPortugal3d):

	rclm2 test_round
	cd test_round
	./script/init 3Dspark
	edit teams
		FCPortugal3d
		TestTeam
	./script/schedule/init teams

For actual rounds, in the `teams` file, write the round's participating team usernames, one per line. For penalty rounds, use `./script/init 3Dpenalty` instead of `3Dspark`.

## NFS

At every code upload deadline (before each round), you should disable writing to the home directory. Simply run `nfsCloseHomes.sh` to close

	ssh cl1-nfs
	RCSoccerSim3dSetup/scripts/nfsCloseHomes.sh

And re-open them with `nfsOpenHomes.sh`

	ssh cl1-nfs
	RCSoccerSim3dSetup/scripts/nfsOpenHomes.sh
	
Dont worry about errors on removing permissions from the log file.

## Clients

Start the proxy on all client machines before running a round.

	ssh cl1-client1
	./start.sh 10.8.3.51 3100 3100
	
and

	ssh cl1-client2
	./start.sh 10.8.3.51 3100 3100

## Viewer

I usually work directly on the monitor machine. If you don't,

	ssh cl1-monitor

Then run `./script/start` in the round directory. Some pointers for during running the group:

- After each half, the simulator must be stopped. To do so, type `end` and press enter in the terminal where the league manager is running. Alternatively, while editing `types/3Dspark/config`, set `USED_MONITOR` to `internal`, or `empty`; this way the league manager continues automatically when the server is killed (e.g. by pressing `shift+X` in RoboViz).
- If the league manager asks to run complementary match, choose `y` (yes) if the match got interrupted erroneously (e.g server crash), or to start a second half.
- To change the schedule by hand (e.g. to rerun a match, or reorder matches), edit the file `var/schedule` in the round directory.
- Logs are compressed and stored automatically in the `archives` directory in the group folder. You only have to compress them at the end of a league, which saves time during matches.

Finally, start RoboViz with `./roboviz.sh` in the Roboviz directory. When the match has started, if you wish to disable them, press `n` for number of players in each team, `i` to show player numbers, `f` to show a mini-map, `0` to highlight the ball. I recommend pressing `space` for the camera to track the ball (if you moved Roboviz to another screen, this shortcut is disabled. Go to menu `Camera` and choose the `Track Ball` option).

To start the game, press `k` for Kick-off!
