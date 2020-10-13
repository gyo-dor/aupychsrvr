#!/bin/bash
echo "###############################################"
echo "TODO: Download syzgy endgame tablebase."
echo "TODO: Setup autostart script"
echo "EXPECTED WORKFLOW. (You must be installed Git and cloned this. You now should be at the cloned folder.)"
echo "1. Install Python 3.7 and pipenv."
echo "2. Install requirements.txt and then lock pipenv."
echo "3. Download Stockfish Chess Engine."
echo "4. Unzipping, then rename to 'engine', then move to ./engines/linux."
echo "5. Configuring Reboot Autostart Engine."
echo "6. Restart then see if it launches on startup."
echo "###############################################"

sudo apt update -y
sudo apt upgrade -y

sudo apt install -y wget
sudo apt install -y zip
sudo apt install -y net-tools

sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa

sudo apt install -y python3.7
sudo apt install -y python3-pip

alias python3.7='/usr/bin/python3.7'

sudo python3.7 -m pip install pipenv
sudo python3.7 -m pipenv install

cd ../

sudo mv aupychsrvr /usr/share
sudo mv chess-server.service /etc/systemd/system

sudo systemctl disable ufw
