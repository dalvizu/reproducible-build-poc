#!/bin/bash
set pipefail
set -ex

export SECRET_BUILD_PATH=swirlds-platform/sdk/data/lib/swirlds-*.jar

source secrets.txt
rm -rf results/
mkdir -p results/1/ results/2/
vagrant exec mkdir -p /home/dan.alvizu/.ssh/
vagrant scp ~/.ssh/id_rsa_temp :/home/dan.alvizu/.ssh/id_rsa
vagrant exec git clone --branch=dalvizu-reproducible-build-poc --recurse-submodules $PRIVATE_REPO
vagrant exec JAVA_HOME=/opt/jdk-17 PATH=\$PATH:\$JAVA_HOME/bin mvn clean deploy -DskipTests
vagrant scp :/vagrant/$SECRET_BUILD_PATH results/1/

git clone --branch=dalvizu-reproducible-build-poc --recurse-submodules git@github.com:swirlds/swirlds-platform.git
pushd swirlds-platform
mvn clean install -DskipTests
popd
cp $SECRET_BUILD_PATH results/2/

diffoscope results/1/ results/2/ | tee results/diff.txt
if [ $? -eq 0 ]; thend
    GREEN='\033[0;32m'
    NC='\033[0m'
    echo -e "${GREEN}Binary files match!${NC}"
else
    RED='\033[0;31m'
    NC='\033[0m'
    echo -e "${RED}Binary files do not match!${NC}"
fi

