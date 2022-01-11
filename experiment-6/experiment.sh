#!/bin/bash

rm -rf results/
mkdir -p results/1 results/2

./mvnw clean install
docker build -t dalvizu-test .
docker save -o results/1/bundle.tar dalvizu-test

vagrant rsync
vagrant exec sudo docker build -t dalvizu-test .
vagrant exec sudo docker save -o results/1/image.tar dalvizu-test
vagrant scp :/vagrant/image.tar results/2/image.tar

diffoscope results/bundle.tar results/image.tar | tee results/diff.txt
if [ $? -eq 0 ]; then
    GREEN='\033[0;32m'
    NC='\033[0m'
    echo -e "${GREEN}Binary files match!${NC}"
else
    RED='\033[0;31m'
    NC='\033[0m'
    echo -e "${RED}Binary files do not match!${NC}"
fi

