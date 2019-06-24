#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y git
sudo apt install -y unzip
sudo apt install -y cmake
sudo apt install -y zlib1g-dev
git clone https://github.com/libra/libra.git
cd libra
./scripts/dev_setup.sh