# Running Rounds

## NFS

At every code upload deadline (before each round), you should disable writing to the home directory. Simply run `nfsCloseHomes.sh` to close, and re-open them with `nfsOpenHomes.sh`. Dont worry about errors on removing permissions from the log file.

## Clients

Start the proxy on all client machines before running a round.

	./start.sh 10.8.3.51 3100 3100

## Viewer

To start the group, start RoboViz with `./roboviz.sh` in the Roboviz directory, and run `./script/start` in the round directory. 

Some pointers for during running the group:

- After each half, the simulator must be stopped. To do so, type `end` and press enter in the terminal where the league manager is running. Alternatively, while editing `types/3Dspark/config`, set `USED_MONITOR` to `internal`, or `empty`; this way the league manager continues automatically when the server is killed (e.g. by pressing `shift+X` in RoboViz).
- If the league manager asks to run complementary match, choose `y` (yes) if the match got interrupted erroneously (e.g server crash), or to start a second half.
- To change the schedule by hand (e.g. to rerun a match, or reorder matches), edit the file `var/schedule` in the round directory.
- Logs are compressed and stored automatically in the `archives` directory in the group folder.
