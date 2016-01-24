#!/bin/bash

set -e
set -x

export ADAM_OPTS="--master yarn-cluster --num-executors 32 --executor-memory 8g --executor-cores 1 --driver-memory 8g --conf spark.yarn.executor.memoryOverhead=3072"
export ADAM_HOME=~/adam
export hdfs_root=hdfs://amp-bdg-master.amp:8020/user/fnothaft/
Input1=HG00096.mapped.ILLUMINA.bwa.GBR.low_coverage.20120522

# mark duplicate reads
time ${ADAM_HOME}/bin/adam-submit ${ADAM_OPTS} -- transform \
    ${hdfs_root}/$Input1.adam \
    ${hdfs_root}/$Input1.bam \
    -mark_duplicate_reads \
    -realign_indels \
    -recalibrate_base_qualities \
    -known_snps ${hdfs_root}/dbsnp132_20101103.adam \
    $@

hdfs dfs -rmr $Input1.bam
