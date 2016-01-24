#!/bin/bash

set -e
set -x

export ADAM_OPTS="--master yarn-cluster --num-executors $1 --executor-memory 11g --executor-cores 1 --driver-memory 14g --conf spark.yarn.executor.memoryOverhead=3072"
export ADAM_HOME=~/adam
export hdfs_root=hdfs://amp-bdg-master.amp:8020/user/fnothaft
Input1=NA12878_high_coverage

# convert data
time ${ADAM_HOME}/bin/adam-submit ${ADAM_OPTS} -- transform \
    hdfs://amp-bdg-master.amp:8020/data/NA12878.mapped.ILLUMINA.bwa.CEU.high_coverage_pcr_free.20130906.bam \
    ${hdfs_root}/$Input1.adam

# mark duplicate reads
time ${ADAM_HOME}/bin/adam-submit ${ADAM_OPTS} -- transform \
    ${hdfs_root}/$Input1.adam \
    ${hdfs_root}/$Input1.mkdup.adam \
    -mark_duplicate_reads \
    -limit_projection

# realign indels
time ${ADAM_HOME}/bin/adam-submit ${ADAM_OPTS} -- transform \
    ${hdfs_root}/$Input1.mkdup.adam \
    ${hdfs_root}/$Input1.ri.adam \
    -realign_indels

# recalibrate quality scores
time ${ADAM_HOME}/bin/adam-submit ${ADAM_OPTS} -- transform \
    ${hdfs_root}/$Input1.ri.adam \
    ${hdfs_root}/$Input1.bqsr.adam \
    -recalibrate_base_qualities \
    -known_snps ${hdfs_root}/dbsnp132_20101103.adam

# sort file for genotyper
time ${ADAM_HOME}/bin/adam-submit ${ADAM_OPTS} -- transform \
    ${hdfs_root}/$Input1.bqsr.adam \
    ${hdfs_root}/$Input1.sorted.adam \
    -sort_reads

# Convert .adam file back to bam for external Genotyper
time ${ADAM_HOME}/bin/adam-submit ${ADAM_OPTS} -- transform \
    ${hdfs_root}/$Input1.sorted.adam \
    ${hdfs_root}/$Input1.sorted.bam \
    -single

# Convert .adam file back to bam for external Genotyper
time ${ADAM_HOME}/bin/adam-submit ${ADAM_OPTS} -- transform \
    ${hdfs_root}/$Input1.bqsr.adam \
    ${hdfs_root}/$Input1.bqsr.bam \
    -sort_reads \
    -single

# do it all, one step
time ${ADAM_HOME}/bin/adam-submit ${ADAM_OPTS} -- transform \
    ${hdfs_root}/$Input1.adam \
    ${hdfs_root}/$Input1.bam \
    -sort_reads \
    -cache \
    -mark_duplicate_reads \
    -recalibrate_base_qualities \
    -realign_indels \
    -known_snps ${hdfs_root}/dbsnp132_20101103.adam \
    -single \
    -limit_projection

hdfs dfs -rmr $Input1.adam \
    $Input1.bam \
    $Input1.mkdup.adam \
    $Input1.ri.adam \
    $Input1.bqsr.adam \
    $Input1.bqsr.bam \
    $Input1.sorted.adam \
    $Input1.sorted.bam 
