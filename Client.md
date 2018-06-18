
# Set-Up -- CLIENTS

## Configuration

Start with basics.

	sudo apt update
	sudo apt install openssh-server

The League Manager uses the root account to log into the different machines. Ubuntu by default disables this account, to enable it give it a password by running:

	sudo passwd root
	sudo passwd -u root

Set up passwordless SSH. First generate an SSH key on the machine and under the account from which you will run the league manager, usually the visualization machine:

	ssh-keygen

Press `Return` on all questions to select the default values, and to choose not to set a password. This will generate a private and public key. For convenience, run:

	sudoedit /etc/ssh/sshd_config
		PermitRootLogin yes
	sudo service ssh restart

## NFS

NFS is used to make home directories available on all machines. Follow the [Quick-Start](https://help.ubuntu.com/community/SettingUpNFSHowTo) steps.

	sudo apt install nfs-common
	sudo mkdir /home/teams
	sudo mount -t nfs -o nolock,proto=tcp,port=2049 10.8.3.51:/users /home/teams
	sudo nano /etc/fstab
		10.8.3.51:/users    /home/teams    nfs    auto,nolock    0    0

The `nolock` option prevents lockups. Other mount options that you may try setting are `rsize` and `wsize` to set read and write block size, where larger values may speed up things. Also see [this](http://www.centos.org/docs/5/html/Deployment_Guide-en-US/s1-nfs-client-config-options.html) and check `man nfs` to see which defaults are already used. The most important way to get NFS stable however is to prevent any writing, as discussed below.

## Accounts (NIS / Manually)

NIS is used to make user accounts available on all machines. You can also make accounts by hand.

If you want to use NIS, then follow [this](https://help.ubuntu.com/community/SettingUpNISHowTo). You can initially skip all steps that involve portmap.

If you prefer to do it manually, for all teams set account and a password equal to the user. Teams can change this password when they log-in. Also add a test team.

	sudo useradd TestTeam -b /home/teams
	echo TestTeam:TestTeam | sudo chpasswd
	sudo useradd FCPortugal3d -b /home/teams
	echo FCPortugal3d:FCPortugal3d | sudo chpasswd
	sudo useradd BahiaRT -b /home/teams
	echo BahiaRT:BahiaRT | sudo chpasswd
	sudo useradd ITAndroids -b /home/teams
	echo ITAndroids:ITAndroids | sudo chpasswd
	sudo useradd KgpKubs -b /home/teams
	echo KgpKubs:KgpKubs | sudo chpasswd
	sudo useradd magmaOffenburg -b /home/teams
	echo magmaOffenburg:magmaOffenburg | sudo chpasswd
	sudo useradd Miracle3D -b /home/teams
	echo Miracle3D:Miracle3D | sudo chpasswd
	sudo useradd UTAustinVilla -b /home/teams	
	echo UTAustinVilla:UTAustinVilla | sudo chpasswd

## Closing Home Directories

When agents write a lot of logging to a team's home directory they will slow down NFS and the network significantly. To prevent this, you should disable writing before each round. Set up log directories for each team on the client machines by running the script `clientMakeLogFolders.sh`.

## Performance mode

To ensure the machine is running at peak performance, enable performance mode.

	sudo apt install cpufrequtils
	sudoedit /etc/init.d/cpufrequtils
		GOVERNOR="performance"

## Proxy

Download and extract the rcssserver proxy onto the client machines from [here](https://github.com/magmaOffenburg/magmaProxy):

	sudo add-apt-repository ppa:webupd8team/java
	sudo apt update
	sudo apt install git oracle-java8-installer
	git clone https://github.com/magmaOffenburg/magmaProxy
	cd magmaProxy
	chmod +x start.sh

Usage instructions are in the included `README.txt` file. Note that the server must run in `sync` mode if the proxy is used. Start the proxy on all client machines before running a round.

	./start.sh 10.8.3.51 3100 3100
