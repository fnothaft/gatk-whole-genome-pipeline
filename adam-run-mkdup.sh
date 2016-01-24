#!/bin/bash

set -e
set -x

export ADAM_OPTS="--master yarn-cluster --num-executors 256 --executor-memory 11g --executor-cores 1 --driver-memory 14g --conf spark.yarn.executor.memoryOverhead=3072"
export ADAM_HOME=~/adam
export hdfs_root=hdfs://amp-bdg-master.amp:8020/user/fnothaft/
Input1=NA12878_high_coverage

# mark duplicate reads
time ${ADAM_HOME}/bin/adam-submit ${ADAM_OPTS} -- transform \
    ${hdfs_root}/$Input1.adam \
    ${hdfs_root}/$Input1.mkdup.adam \
    -mark_duplicate_reads

hdfs dfs -rmr $Input1.mkdup.adam

# mark duplicate reads
time ${ADAM_HOME}/bin/adam-submit ${ADAM_OPTS} -- transform \
    ${hdfs_root}/$Input1.adam \
    ${hdfs_root}/$Input1.mkdup.adam \
    -mark_duplicate_reads \
    -limit_projection

hdfs dfs -rmr $Input1.mkdup.adam

# mark duplicate reads
time ${ADAM_HOME}/bin/adam-submit ${ADAM_OPTS} -- transform \
    hdfs://amp-bdg-master.amp:8020/data/NA12878.mapped.ILLUMINA.bwa.CEU.high_coverage_pcr_free.20130906.bam \
    ${hdfs_root}/$Input1.mkdup.adam \
    -mark_duplicate_reads

hdfs dfs -rmr $Input1.mkdup.adam
