# Running Rounds

## NFS

At every code upload deadline (before each round), you should disable writing to the home directory. Simply run `nfsCloseHomes.sh` to close, and re-open them with `nfsOpenHomes.sh`. Dont worry about errors on removing permissions from the log file.

## Clients

Start the proxy on all client machines before running a round.

	./start.sh 10.8.3.51 3100 3100

## Viewer

First run `./script/start` in the round directory. Some pointers for during running the group:

- After each half, the simulator must be stopped. To do so, type `end` and press enter in the terminal where the league manager is running. Alternatively, while editing `types/3Dspark/config`, set `USED_MONITOR` to `internal`, or `empty`; this way the league manager continues automatically when the server is killed (e.g. by pressing `shift+X` in RoboViz).
- If the league manager asks to run complementary match, choose `y` (yes) if the match got interrupted erroneously (e.g server crash), or to start a second half.
- To change the schedule by hand (e.g. to rerun a match, or reorder matches), edit the file `var/schedule` in the round directory.
- Logs are compressed and stored automatically in the `archives` directory in the group folder.

Then start RoboViz with `./roboviz.sh` in the Roboviz directory. When the match has started, if you wish to disable them, press `n` for number of players in each team, `i` to show player numbers, `f` to show a mini-map, `0` to highlight the ball. We recommend pressing `space` for the camera to track the ball (if you moved Roboviz to another screen, this shortcut is disabled. Go to menu `Camera` and choose the `Track Ball` option).

To start the game, press `k` for Kick-off!