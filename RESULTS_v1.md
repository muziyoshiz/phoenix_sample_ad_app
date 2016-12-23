# Benchmark Results

- 3 VMs: 1 application server, 1 monitoring node and 1 HBase server
- Spec: [GMO AppsCloud Type SS High-CPU (ver2.1)](https://cloud.gmo.jp/en/ver2/)
    - 4vCPU (2.40GHz)
    - 8GB RAM

| URL        | Configs         | Local cache | Access Log  |
|:-----------|:----------------|:------------|:------------|
| sample1.js | Fixed value     | No          | No          |
| sample2.js | Read from HBase | No          | No          |
| sample3.js | Read from HBase | Yes, Always | No          |
| sample4.js | Read from HBase | Yes, Always | Yes (File)  |
| sample5.js | Read from HBase | Yes, Always | Yes (HBase) |

The tests were executed three times for each URLs. The following results are the second-best throughputs.

| URL        | Throughput (req/s) | Latency (ms) | Consistency (σ ms) |
|------------:|------------------:|--------------:|------------------:|
| sample1.js | 12636.18 |    8.36 |   5.75 |
| sample2.js |  8063.61 |   12.42 |   3.10 |
| sample3.js | 11556.05 |    9.07 |   5.91 |
| sample4.js |  2883.61 |   34.70 |   4.96 |
| sample5.js |    93.14 | 1070.00 | 129.72 |

## sample1.js: No access logs, and fixed configs

```
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample1.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample1.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     8.40ms    5.58ms  99.32ms   73.55%
    Req/Sec   629.69    166.34     2.14k    77.50%
  Latency Distribution
     50%    7.93ms
     75%   11.02ms
     90%   14.68ms
     99%   27.22ms
  376321 requests in 30.03s, 121.01MB read
Requests/sec:  12531.71
Transfer/sec:      4.03MB
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample1.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample1.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     8.36ms    5.75ms  80.06ms   72.81%
    Req/Sec   634.87    178.71     2.35k    76.28%
  Latency Distribution
     50%    7.68ms
     75%   11.16ms
     90%   15.26ms
     99%   27.14ms
  379410 requests in 30.03s, 122.01MB read
Requests/sec:  12636.18
Transfer/sec:      4.06MB
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample1.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample1.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     8.25ms    5.65ms 103.59ms   72.12%
    Req/Sec   642.35    174.93     1.92k    76.48%
  Latency Distribution
     50%    7.68ms
     75%   11.01ms
     90%   14.97ms
     99%   26.13ms
  383875 requests in 30.03s, 123.44MB read
Requests/sec:  12783.49
Transfer/sec:      4.11MB
```

## sample2.js: No access logs, and configs from HBase

```
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample2.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample2.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    13.09ms    4.72ms  91.57ms   86.47%
    Req/Sec   388.80     62.21   545.00     83.73%
  Latency Distribution
     50%   12.02ms
     75%   14.23ms
     90%   17.68ms
     99%   31.79ms
  232423 requests in 30.04s, 74.74MB read
Requests/sec:   7738.38
Transfer/sec:      2.49MB
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample2.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample2.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    12.42ms    3.10ms  49.97ms   79.44%
    Req/Sec   405.12     30.97   515.00     70.73%
  Latency Distribution
     50%   11.85ms
     75%   13.62ms
     90%   15.99ms
     99%   23.58ms
  242167 requests in 30.03s, 77.87MB read
Requests/sec:   8063.61
Transfer/sec:      2.59MB
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample2.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample2.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    12.23ms    3.03ms  62.33ms   79.91%
    Req/Sec   411.22     32.06   525.00     72.15%
  Latency Distribution
     50%   11.67ms
     75%   13.38ms
     90%   15.69ms
     99%   23.09ms
  245802 requests in 30.03s, 79.04MB read
Requests/sec:   8184.36
Transfer/sec:      2.63MB
```

## sample3.js: No access logs, and configs from HBase or local cache

```
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample3.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample3.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     9.07ms    5.91ms  88.44ms   72.81%
    Req/Sec   580.54    152.32     1.87k    77.63%
  Latency Distribution
     50%    8.48ms
     75%   12.01ms
     90%   15.96ms
     99%   28.33ms
  346955 requests in 30.02s, 111.57MB read
Requests/sec:  11556.05
Transfer/sec:      3.72MB
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample3.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample3.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     9.15ms    6.08ms 122.48ms   73.24%
    Req/Sec   577.97    155.29     1.77k    77.10%
  Latency Distribution
     50%    8.58ms
     75%   12.04ms
     90%   16.32ms
     99%   29.51ms
  345425 requests in 30.02s, 111.08MB read
Requests/sec:  11504.92
Transfer/sec:      3.70MB
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample3.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample3.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     8.90ms    5.79ms  98.65ms   73.18%
    Req/Sec   590.81    158.65     3.13k    78.42%
  Latency Distribution
     50%    8.39ms
     75%   11.61ms
     90%   15.63ms
     99%   27.65ms
  353091 requests in 30.03s, 113.54MB read
Requests/sec:  11758.42
Transfer/sec:      3.78MB
```

## sample4.js: Access logs to file, and configs from HBase or local cache

```
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample4.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample4.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    35.13ms    5.37ms 120.72ms   86.56%
    Req/Sec   142.92     15.93   252.00     76.87%
  Latency Distribution
     50%   34.79ms
     75%   37.28ms
     90%   40.08ms
     99%   46.29ms
  85532 requests in 30.05s, 27.50MB read
Requests/sec:   2846.53
Transfer/sec:      0.92MB
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample4.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample4.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    34.70ms    4.96ms 125.31ms   91.22%
    Req/Sec   144.77     13.46   320.00     73.50%
  Latency Distribution
     50%   34.58ms
     75%   36.48ms
     90%   38.33ms
     99%   43.71ms
  86640 requests in 30.05s, 27.86MB read
Requests/sec:   2883.61
Transfer/sec:      0.93MB
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample4.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample4.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    34.65ms    5.44ms 102.99ms   88.57%
    Req/Sec   144.83     16.37   290.00     82.83%
  Latency Distribution
     50%   34.50ms
     75%   36.77ms
     90%   39.11ms
     99%   48.16ms
  86679 requests in 30.04s, 27.87MB read
Requests/sec:   2885.06
Transfer/sec:      0.93MB
```

## sample5.js: Access logs to HBase, and configs from HBase or local cache

```
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample5.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample5.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.07s   129.72ms   1.27s    57.14%
    Req/Sec     5.95      7.10    40.00     93.18%
  Latency Distribution
     50%    1.09s 
     75%    1.17s 
     90%    1.22s 
     99%    1.26s 
  2800 requests in 30.06s, 0.90MB read
Requests/sec:     93.14
Transfer/sec:     30.65KB
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample5.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample5.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.06s   131.38ms   1.26s    64.29%
    Req/Sec     5.82      6.97    40.00     93.75%
  Latency Distribution
     50%    1.08s 
     75%    1.18s 
     90%    1.24s 
     99%    1.25s 
  2800 requests in 30.06s, 0.90MB read
Requests/sec:     93.15
Transfer/sec:     30.66KB
[root@myoshiz-ex-2 wrk]# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample5.js?id=1&callback=EXAMPLE.process"
Running 30s test @ http://myoshiz-ex-1:4000/api/sample5.js?id=1&callback=EXAMPLE.process
  20 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.09s   126.64ms   1.25s    70.37%
    Req/Sec     5.74      6.49    40.00     93.52%
  Latency Distribution
     50%    1.12s 
     75%    1.18s 
     90%    1.22s 
     99%    1.24s 
  2700 requests in 30.06s, 0.87MB read
Requests/sec:     89.81
Transfer/sec:     29.56KB
```
