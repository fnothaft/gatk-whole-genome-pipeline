#!/bin/bash

. ~/.bashrc

hdfs dfs -rmr NA12878_high_coverage.*.adam

time ./adam-test-small.sh

#time ./adam-test.sh -aligned_read_predicate

#hdfs dfs -rmr NA12878_high_coverage.*.adam

#time ./adam-test.sh -aligned_read_predicate -limit_projection

#time ./adam-test.sh -limit_projection

#hdfs dfs -rmr NA12878_high_coverage.*.adam

time ./adam-run-small.sh

#time ./adam-run-all.sh -aligned_read_predicate

#hdfs dfs -rmr NA12878_high_coverage.*.adam

#time ./adam-run-all.sh -aligned_read_predicate -limit_projection

#time ./adam-run-all.sh -limit_projection
