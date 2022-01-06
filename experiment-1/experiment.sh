#!/bin/bash

rm -rf results/
mkdir -p results/
./mvnw clean install; cp target/*.jar results/1.jar
./mvnw clean install; cp target/*.jar results/2.jar
diffoscope results/1.jar results/2.jar > results/diffoscope-results.txt

