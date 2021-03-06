#!/bin/bash

echo "###############################################"
echo "TODO: Use persistent storage instead. Mount it at /home/chess-server"
echo "TODO: Download syzgy endgame tablebase and place it in /home/chess-server/tablebases."
echo "EXPECTED WORKFLOW. (You must have installed Git and cloned this. You now should be at the cloned folder.)"
echo "1. Install Python 3.7, pip, and pipenv."
echo "2. Install pipenv requirements.txt and then lock pipenv."
echo "3. Configuring reboot autostart engine."
echo "4. Restart then see if it launches on startup."
echo "###############################################"


echo "[== Installing dependencies ==]"

sudo apt update -y
sudo apt upgrade -y

sudo apt install -y wget
sudo apt install -y zip
sudo apt install -y net-tools
sudo apt install -y ufw

sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa

sudo apt install -y python3.7
sudo apt install -y python3-pip

echo "alias python3.7='/usr/bin/python3.7'" >> ~/.bashrc
. ~/.bashrc


echo "[==== Configuring data disk ====]"

mt_dir='/chessdisk'
size='4G'
lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"

if sudo grep -qs $mt_dir /proc/mounts; then
    echo "The disk was mounted. No need to mount again."
else
    echo "Mounting the disk..."
    sd_disks=$(lsblk -o NAME,SIZE,MOUNTPOINT | grep -i "sd" | grep -i " $size")
    disk_loc=''

    if [[ $sd_disks == *"sda"* ]]; then
        echo "Disk is in sda!"
        disk_loc='/dev/sda1'
    elif [[ $sd_disks == *"sdb"* ]]; then
        echo "Disk is in sdb!"
        disk_loc='/dev/sdb1'
    elif [[ $sd_disks == *"sdc"* ]]; then
        echo "Disk is in sdc!"
        disk_loc='/dev/sdc1'
    elif [[ $sd_disks == *"sdd"* ]]; then
        echo "Disk is in sdd!"
        disk_loc='/dev/sdd1'
    fi

    disk_symbol=${disk_loc:0:8}
    fs_uuid=$(blkid -o value -s UUID $disk_loc)
    sudo parted $disk_symbol --script mklabel gpt mkpart xfspart xfs 0% 100%
    sudo mkfs.xfs $disk_loc
    sudo partprobe $disk_loc
    sudo mkdir $mt_dir
    sudo mount $disk_loc $mt_dir
    sudo chmod -R 777 $mt_dir
    sudo echo "UUID=$fs_uuid $mt_dir xfs defaults,nofail 1 2" >> /etc/fstab
    echo "Finished mount disk."
fi

lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"


echo "[==== Configuring chess server ====]"

sudo mv chess-server.service /etc/systemd/system

cd ../
sudo rm -r "$mt_dir/aupychsrvr"
sudo mv aupychsrvr $mt_dir
sudo chmod -R 777 $mt_dir

cd "$mt_dir/aupychsrvr"
sudo python3.7 -m pip install pipenv
sudo python3.7 -m pipenv install

sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 5080
sudo ufw enable

sudo systemctl enable chess-server.service
