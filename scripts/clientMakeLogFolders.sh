#!/bin/bash
sudo mkdir /teamlogs
cd /home/teams
for t in *
do
  sudo mkdir /teamlogs/$t
  sudo chown $t:$t /teamlogs/$t
done