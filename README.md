# RoboCup 3D Soccer Simulation

# Organizing Committee Guide

## Introduction

This document aims to provide a complete guide to the Organizing Committee (OC) of a RoboCup 3D Soccer Simulation competition. It provides a platform to transfer knowledge and experience gained from past competitions. Examples of content it should have include, but are not limited to: hardware requirements; installation instructions; scheduling guides; tips on rules; experience of extraordinary situations and rulings.

## Hardware Machines

To run a competition,  the following list of machines is the bare minimum that  is required:

- 1x Server machine; as many cores as possible (simspark using ODE-TBB can in theory use 22 cores in parallel, but 8 (or 4 hyperthreaded) cores usually suffices).
- 2x Client/Agent machines; again as many cores as possible, as each will run 11 agents.
- 1x Monitor, keyboard, mouse.
- Decent size HDs for all machines, e.g. 500GB; for the server machine to store match logfiles, for client machines to store team logfiles.

Furthermore, the following is highly advised to have things run more smoothly:
	
- 1x Visualization machine; mid-range GPU. If not available, the server machine should be equipped with such a GPU and used as the visualization machine.
- Monitor, keyboard and mouse for each available machine.
- 1x File server machine, to host NFS and NIS if used.

The above cluster of machines can be repeated to run multiple matches in parallel. With ~20+ teams at least 2 of these clusters is needed to be able to run all matches. An extra cluster for teams to test on is helpful as well.


## Network

To build a network, a Gigabit switch + NICs and CAT6 cables must be used.
It must be possible to physically disconnect the competition network from the internet/event LAN, which must be done during matches to restrict interference. If using multiple clusters, having the ability to separate them physically may help stability, though when using NFS this means you need a mirroring file server for each cluster.
The competition machines should have static IPs.

## OS

Choose a recent Linux OS that you are comfortable with, and that you know of that the simulator runs on. Most teams will be familiar with Ubuntu, other popular choice is Fedora.
Choose a 64 bit OS.
Have several installation methods ready, with different versions if unsure, and both on disk and on USB drive in case the machines don’t support one.

During installation, give each machine a useful host name (e.g. server1, agent1, monitor1).

## Installation Order

Start with setting up the file-server (check `NFS.md`). On these examples, it was on the network 10.8.3.0, and with IP 10.8.3.51. You usually have a single-file server (even with multiple clusters), unless there is a large amount of teams.

Then set up the server (check `Server.md`). On these examples, it had IP 10.8.3.51 (same as the NFS server).

Next are the clients (check `Client.md`). On these examples, they had IPs 10.8.3.52 and 10.8.3.54.

Finally, the viewer (check `Viewer.md`). On these examples, it had IP 10.8.3.53.

To run rounds, follow the instructions on `Running Rounds.md`.