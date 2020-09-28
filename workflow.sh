
echo "###############################################"
echo "EXPECTED WORKFLOW. (You must be installed Git and cloned this. You now should be at the cloned folder.)"
echo "1. Install Python 3.7 and pipenv."
echo "2. Install requirements.txt and then lock pipenv."
echo "3. Downloading Stockfish Chess Engine."
echo "4. Unzipping, then rename to 'engine', then move to ./engines/linux."
echo "5. Configuring Reboot Autostart Engine."
echo "6. Restart then see if it launches on startup."
echo "###############################################"

sudo apt update -y
sudo apt upgrade -y

sudo apt install -y wget
sudo apt install -y zip

sudo add-apt-repository ppa:deadsnakes/ppa
echo -ne '\n'

sudo apt install -y python3.7
sudo apt install -y python3-pip

sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1

pip3 install pipenv
python3 -m pipenv install

echo "###############################################"
echo "Downloading and configuring Stockfish Chess Engine"
echo "###############################################"

filename='stockfish_20092708_x64_avx2'

wget https://abrok.eu/stockfish/builds/1dbd2a1ad548b3ca676f7da949e1a998c64b836b/linux64avx2/stockfish_20092708_x64_avx2.zip
unzip "$filename.zip"
mv $filename ./engines/linux/engine