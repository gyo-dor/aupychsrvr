
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

alias python3.7='/usr/bin/python3.7'

sudo python3.7 -m pip install pipenv
sudo python3.7 -m pipenv install

echo "###############################################"
echo "Downloading and configuring Stockfish Chess Engine"
echo "###############################################"

wget https://abrok.eu/stockfish/builds/767b4f4fbe5ab2e63aceabd9005f4e1eb7cbcb51/linux64bmi2/stockfish_20100519_x64_bmi2.zip
filename='stockfish_20100519_x64_bmi2'

unzip "$filename.zip"
mv $filename engine
mv engine engines/linux
rm "$filename.zip"