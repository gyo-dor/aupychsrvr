#!/bin/bash
echo "###############################################"
echo "TODO: Downloading and configuring Stockfish Chess Engine"
echo "###############################################"

read chessurl

wget chessurl
filename='stockfish_20100519_x64_bmi2'

unzip "$filename.zip"
mv $filename engine
mv engine engines/linux
rm "$filename.zip"