#!/bin/bash
echo "###############################################"
echo "TODO: Downloading and configuring Stockfish Chess Engine"
echo "###############################################"

wget https://abrok.eu/stockfish/builds/767b4f4fbe5ab2e63aceabd9005f4e1eb7cbcb51/linux64bmi2/stockfish_20100519_x64_bmi2.zip
filename='stockfish_20100519_x64_bmi2'

unzip "$filename.zip"
mv $filename engine
mv engine engines/linux
rm "$filename.zip"