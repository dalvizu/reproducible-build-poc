#!/bin/bash

rm -rf results/
mkdir -p results/1 results/2

# do windows crap, copy to results/1

./mvnw clean install
cp target/*.jar results/2.jar
diffoscope results/1.jar results/2.jar > results/diff.txt
if [ $? -eq 0 ]; then
    GREEN='\033[0;32m'
    NC='\033[0m'
    echo -e "${GREEN}Binary files match!${NC}"
else
    RED='\033[0;31m'
    NC='\033[0m'
    echo -e "${RED}Binary files do not match!${NC}"
fi

