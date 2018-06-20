# File Server Set-Up

## NFS

NFS is used to make home directories available on all machines. Follow the [Quick-Start](https://help.ubuntu.com/community/SettingUpNFSHowTo) steps.

	sudo apt install nfs-kernel-server
	sudo mkdir /home/teams
	sudo mkdir -p /export/users
	sudo chmod 777 /export
	sudo chmod 777 /export/users
	sudo mount --bind /home/teams /export/users

Then edit some files to keep these directories exported even after a reboot.

	sudoedit /etc/fstab
		/home/teams    /export/users   none    bind  0  0
	sudoedit /etc/exports
		/export       10.8.3.0/24(rw,fsid=0,insecure,no_subtree_check,async)
		/export/users 10.8.3.0/24(rw,nohide,insecure,no_subtree_check,async)

## Accounts (NIS / Manually)

NIS is used to make user accounts available on all machines. You can also make accounts by hand.

If you want to use NIS, then follow [this](https://help.ubuntu.com/community/SettingUpNISHowTo). You can initially skip all steps that involve portmap.

If you prefer to do it manually, for all teams set account and a disabled password. Also add a test team.

	sudo mkdir /home/teams
	sudo useradd TestTeam -m -b /home/teams
	sudo useradd FCPortugal3d -m -b /home/teams
	sudo useradd BahiaRT -m -b /home/teams
	sudo useradd ITAndroids -m -b /home/teams
	sudo useradd KgpKubs -m -b /home/teams
	sudo useradd magmaOffenburg -m -b /home/teams
	sudo useradd Miracle3D -m -b /home/teams
	sudo useradd UTAustinVilla -m -b /home/teams

## Performance mode

To ensure the machine is running at peak performance, enable performance mode. For an 8-core machine, this did the trick:

    for i in {0..7}; do echo performance > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor; done

This does not seem to work:

	sudo apt install cpufrequtils
	sudoedit /etc/init.d/cpufrequtils
		GOVERNOR="performance"

We're not sure how to make this work upon reboot.

## Closing Home Directories

Set up log directories for each team by running the `nfsMakeLogFolders.sh` script. Now when teams log to this directory, the output is written to the current machine, not to NFS.

At every code upload deadline (before each round), you should disable writing to the home directory. Simply run `nfsCloseHomes.sh` to close, and re-open them with `nfsOpenHomes.sh`. Dont worry about errors on removing permissions from the log file.
