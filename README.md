# PhoenixSampleAdApp

## What is it?

In general, Ad serving system has many application servers to do:

- Read configurations from database
- Cache the configurations
- Record access logs
- Generate a response such as JSON, JSONP or JavaScript

This is a simple example of such Ad application servers written in Elixir/Phoenix.

## Feature

This application receives two URL parameters. It find URLs in HBase by the specified ID and generate a JSON message. Then, it returns the JSON as JSONP wrapped by a function that has the specified callback name.

```
http://server:4000/api/sample1.js?id=1&callback=Example.process
```

For benchmarks this application supports the following URLs. sample4.js is the most realistic combination.

| URL        | Configs         | Local cache | Access Log  |
|:-----------|:----------------|:------------|:------------|
| sample1.js | Fixed value     | No          | No          |
| sample2.js | Read from HBase | No          | No          |
| sample3.js | Read from HBase | Yes, Always | No          |
| sample4.js | Read from HBase | Yes, Always | Yes (File)  |
| sample5.js | Read from HBase | Yes, Always | Yes (HBase) |

## How to Use

### 1. Setup HBase

Please craete HBase tables and put rows as follows.

```
hbase> create 'settings', {NAME => 'f1'}
hbase> create 'access_logs', {NAME => 'f1'}
hbase> put 'settings', '1', 'f1:urls', '["http://ad1.example.com/tag.js","http://ad2.example.com/tag.js"]'
```

### 2. Modify ZooKeeper quorum's host name

If you use a remote HBase server, please modify Zookeeper quorum's hostname in config/prod.secret.exs.

```
config :diver,
  zk: [quorum_spec: "localhost",
       base_path: "/hbase"],
  jvm_args: ["-Djava.awt.headless=true"]
```

### 3. Execute

The following arguments --name and --cookie are required by Diver, HBase client.

```
$ MIX_ENV=prod mix compile
$ MIX_ENV=prod PORT=4000 iex --name "myserver@127.0.0.1" --cookie "mycookie" -S mix phoenix.server
```

## Benchmark

### Hardware

- 3 VMs: 1 application server, 1 monitoring node and 1 HBase server
- Spec: [GMO AppsCloud Type SS High-CPU (ver2.1)](https://cloud.gmo.jp/en/ver2/)
    - 4vCPU (2.40GHz)
    - 8GB RAM

## Software

- CentOS 7.0
- Erlang/OTP 19
- Elixir 1.3.4
- Phoenix 1.2.1
- [Diver](https://github.com/novabyte/diver) 0.2.0
- [Cachex](https://github.com/zackehh/cachex) 2.0.1
- [LoggerFileBackend](https://github.com/onkel-dirtus/logger_file_backend) 0.0.9

## Monitoring tool

I use wrk same as [mroth/phoenix-showdown](https://github.com/mroth/phoenix-showdown).

```
# wrk -t20 -c100 -d30S --timeout 1000 --latency "http://myoshiz-ex-1:4000/api/sample1.js?id=1&callback=EXAMPLE.process"
```

## Results

The tests were executed three times for each URLs. The following results are the second-best throughputs.

| URL        | Throughput (req/s) | Latency (ms) | Consistency (σ ms) |
|------------:|------------------:|--------------:|------------------:|
| sample1.js | 12636.18 |    8.36 |   5.75 |
| sample2.js |  8063.61 |   12.42 |   3.10 |
| sample3.js | 11556.05 |    9.07 |   5.91 |
| sample4.js |  2883.61 |   34.70 |   4.96 |
| sample5.js |    93.14 | 1070.00 | 129.72 |

The results show that HBase get increases the latency by about 4 ms and Cachex is effective to decrease the latency.
It is also shown that the logging to files increases the latency by about 26 ms.

You can view [the detailed results](/RESULTS_v1.md).
