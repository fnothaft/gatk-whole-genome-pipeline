#!/bin/bash

cd ~/adam

#git fetch upstream
#git checkout -b ssf-test upstream/master
#git pull --commit https://github.com/fnothaft/adam.git ssf

#~/apache-maven-3.3.3/bin/mvn clean package -DskipTests

#~/gatk-whole-genome-pipeline/adam-test.sh 2>&1 | tee no-limit.log
#~/gatk-whole-genome-pipeline/adam-test.sh -limit_projection 2>&1 | tee limit.log

#git checkout -b ssf-plus-599
#git pull --commit https://github.com/fnothaft/adam.git eliminate-metadata

#git checkout ssf-plus-599

#~/apache-maven-3.3.3/bin/mvn clean package -DskipTests
~/gatk-whole-genome-pipeline/adam-test.sh -limit_projection 2>&1 | tee 599.log
