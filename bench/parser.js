#!/usr/bin/node

'use strict';

// arg parsing
let args = process.argv.slice(2);
let filepath = args[0];

if (!filepath) {
    process.exit(1);
}

// requires
const fs = require('fs');
const os = require('os');

// fio raw report
let j = JSON.parse(fs.readFileSync(filepath, 'utf8'));

// heading
let heading = ['hostname', 'workload', 'ioengine', 'runtime', 'filesize', 'blocksize', 'iodepth', 'cores', 'iops', 'bw kB/s', 'lat_min (ns)', 'lat_max (ns)', 'lat_mean (ns)', 'cpu_usr', 'cpu_sys']
console.log(heading.join(','));

let hostname = os.hostname();
// generate report
j.jobs.map(function (job) {
    let template = [hostname, job['job options'].rw, j['global options'].ioengine, j['global options'].runtime, j['global options'].filesize, job['job options'].bs, j['global options'].iodepth, job['job options'].numjobs, job.read.iops + job.write.iops, job.read.bw + job.write.bw, job.read.lat_ns.min + job.write.lat_ns.min,job.read.lat_ns.max + job.write.lat_ns.max, job.read.lat_ns.mean + job.write.lat_ns.mean,job.usr_cpu, job.sys_cpu];
    console.log(template.join(','));
});