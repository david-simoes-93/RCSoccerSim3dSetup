#!/bin/bash
cd /home/teams
for t in *
do
  sudo ln -s /teamlogs/$t $t/log
done
