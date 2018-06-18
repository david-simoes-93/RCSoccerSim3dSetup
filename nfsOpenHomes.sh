#!/bin/bash
cd /home/teams
for t in *
do
    chmod u+w $t -R
done
