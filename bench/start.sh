#!/bin/bash

set -e

# variables
HOSTNAME=$(hostname)
FIO_JOB_FILE=$(mktemp)

# setup defaults
JOB_RUNTIME=${JOB_RUNTIME:-120} # length of each test run in seconds.
JOB_FILESIZE=${JOB_FILESIZE:-128m} # the file size used in a test.
JOB_CORES=${JOB_CORES:-1} # the number of cores dedicated to fio to run job.

# fio job description
#
# iodepth 1 is good for sync performance test, it ensures that the io is completed before the next io
# block size of 4k for random, 4m for sequential testing.

cat << fio_job_template_eof > $FIO_JOB_FILE
[global]
ioengine=sync
atomic=1
direct=1
iodepth=1
fallocate=none
directory=/fio_test
runtime=${JOB_RUNTIME}
time_based=1
filesize=${JOB_FILESIZE}
group_reporting

[random-read]
bs=4k
rw=randread
numjobs=${JOB_CORES}
stonewall

[random-write]
bs=4k
rw=randwrite
numjobs=${JOB_CORES}
stonewall

[sequential-read]
bs=4m
rw=read
numjobs=${JOB_CORES}
stonewall

[sequential-write]
bs=4m
rw=write
numjobs=${JOB_CORES}
stonewall
fio_job_template_eof

echo Running fio job file at $(date)
# run fio
fio -f ${FIO_JOB_FILE} --output-format=json 2> /proc/1/fd/2 1> ./reports/${HOSTNAME}.fio.json

echo Completed fio job at $(date)

echo Starting parser at $(date)
# run parser
./parser.js ./reports/${HOSTNAME}.fio.json | tee ./reports/${HOSTNAME}.fio.csv | xargs -I{} echo "   {}"

echo Completed parser at $(date)
echo Check report file .${PWD}/reports/${HOSTNAME}.fio.csv