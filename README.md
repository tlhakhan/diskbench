# README
A disk benchmark docker-compose project.  It uses [axboe/fio](https://github.com/axboe/fio) to perform the benchmark.  It then parses and summarizes the result into a csv file located in the reports folder.
- Jen Axboe's fio documentation can be found [here](https://fio.readthedocs.io/en/latest/fio_doc.html).

## Example run
- Build the project containers using `docker-compose build`.
- Run `docker-compose run diskbench` to start the benchmark.
```
% docker-compose run diskbench
Running fio job file at Sun Jul 12 15:02:37 UTC 2020
Completed fio job at Sun Jul 12 15:06:39 UTC 2020
Starting parser at Sun Jul 12 15:06:39 UTC 2020
   hostname,workload,ioengine,runtime,filesize,blocksize,iodepth,cores,iops,bw kB/s,lat_min,lat_max,lat_mean,cpu_usr,cpu_sys
   722d5edb9880,randread,sync,60,128m,4k,1,1,9005.283245,36021,53002,260227168,107216.436189,5.36,44.85
   722d5edb9880,randwrite,sync,60,128m,4k,1,1,5602.20663,22408,103437,331103604,174926.753357,2.841667,40.906667
   722d5edb9880,read,sync,60,128m,4m,1,1,1023.982934,4194234,788742,286774753,974155.967269,1.015,70.436667
   722d5edb9880,write,sync,60,128m,4m,1,1,890.851819,3648929,863684,108988045,1119245.690227,11.535,58.46
Completed parser at Sun Jul 12 15:06:39 UTC 2020
Check report file ./bench/reports/722d5edb9880.fio.csv
```

## Notes
- Update the `JOB_*` environment variables in `docker-compose.yml` or override with a separate yaml file.
- The `JOB_*` variable builds the fio job file.  See `start.sh` for more information.