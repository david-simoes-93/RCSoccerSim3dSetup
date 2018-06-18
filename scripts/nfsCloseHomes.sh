#!/bin/bash
cd /home/teams
for t in *
do
    chmod a-w $t -R
    chmod u+w $t/log -R
done
