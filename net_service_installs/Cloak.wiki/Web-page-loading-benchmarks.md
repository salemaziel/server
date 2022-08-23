The following tests are conducted using ApacheBench and proxychains, with the client in the UK and the server as an AWS EC2 instance in Ohio

# Youtube
`proxychains ab -l -n 100 -c 7 https://www.youtube.com/`

**GoQuiet**
```
Server Software:        YouTube
Server Hostname:        www.youtube.com
Server Port:            443
SSL/TLS Protocol:       TLSv1.2,ECDHE-ECDSA-CHACHA20-POLY1305,256,256
TLS Server Name:        www.youtube.com

Document Path:          /
Document Length:        Variable

Concurrency Level:      7
Time taken for tests:   30.451 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      30077327 bytes
HTML transferred:       29989127 bytes
Requests per second:    3.28 [#/sec] (mean)
Time per request:       2131.577 [ms] (mean)
Time per request:       304.511 [ms] (mean, across all concurrent requests)
Transfer rate:          964.58 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      435  469  19.3    469     502
Processing:  1247 1599 207.3   1574    2380
Waiting:      137  153   6.4    153     171
Total:       1693 2068 209.7   2055    2821

Percentage of the requests served within a certain time (ms)
  50%   2055
  66%   2120
  75%   2169
  80%   2207
  90%   2327
  95%   2507
  98%   2621
  99%   2821
 100%   2821 (longest request)
 ```
 
**Cloak**
```
Server Software:        YouTube
Server Hostname:        www.youtube.com
Server Port:            443
SSL/TLS Protocol:       TLSv1.2,ECDHE-ECDSA-CHACHA20-POLY1305,256,256
TLS Server Name:        www.youtube.com

Document Path:          /
Document Length:        Variable

Concurrency Level:      7
Time taken for tests:   27.195 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      30383483 bytes
HTML transferred:       30294977 bytes
Requests per second:    3.68 [#/sec] (mean)
Time per request:       1903.664 [ms] (mean)
Time per request:       271.952 [ms] (mean, across all concurrent requests)
Transfer rate:          1091.05 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      245  440 191.1    386     953
Processing:   862 1420 310.9   1425    2338
Waiting:      139  175  66.0    155     525
Total:       1291 1859 342.1   1859    2724

Percentage of the requests served within a certain time (ms)
  50%   1859
  66%   1973
  75%   2031
  80%   2154
  90%   2372
  95%   2588
  98%   2695
  99%   2724
 100%   2724 (longest request)
```

# Google
`proxychains ab -l -n 100 -c 7 https://www.google.com/`

**GoQuiet**
```
Server Software:        gws
Server Hostname:        www.google.com
Server Port:            443
SSL/TLS Protocol:       TLSv1.2,ECDHE-ECDSA-CHACHA20-POLY1305,256,256
TLS Server Name:        www.google.com

Document Path:          /
Document Length:        Variable

Concurrency Level:      7
Time taken for tests:   11.091 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      1393107 bytes
HTML transferred:       1317207 bytes
Requests per second:    9.02 [#/sec] (mean)
Time per request:       776.358 [ms] (mean)
Time per request:       110.908 [ms] (mean, across all concurrent requests)
Transfer rate:          122.67 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      435  467  18.4    466     501
Processing:   247  274  24.2    269     385
Waiting:      148  166  18.5    163     281
Total:        686  741  35.3    735     867

Percentage of the requests served within a certain time (ms)
  50%    735
  66%    747
  75%    766
  80%    771
  90%    783
  95%    790
  98%    848
  99%    867
 100%    867 (longest request)
 ```
 
**Cloak**
```
Server Software:        gws
Server Hostname:        www.google.com
Server Port:            443
SSL/TLS Protocol:       TLSv1.2,ECDHE-ECDSA-CHACHA20-POLY1305,256,256
TLS Server Name:        www.google.com

Document Path:          /
Document Length:        Variable

Concurrency Level:      7
Time taken for tests:   7.668 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      1393126 bytes
HTML transferred:       1317526 bytes
Requests per second:    13.04 [#/sec] (mean)
Time per request:       536.784 [ms] (mean)
Time per request:       76.684 [ms] (mean, across all concurrent requests)
Transfer rate:          177.41 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      303  319  17.6    316     405
Processing:   177  193  19.2    188     283
Waiting:      170  185  13.0    182     269
Total:        485  513  31.6    504     679

Percentage of the requests served within a certain time (ms)
  50%    504
  66%    511
  75%    515
  80%    518
  90%    529
  95%    591
  98%    653
  99%    679
 100%    679 (longest request)
 ```

# Github
`proxychains ab -l -n 100 -c 7 https://www.github.com/`

**GoQuiet**
```
Server Software:
Server Hostname:        www.github.com
Server Port:            443
SSL/TLS Protocol:       TLSv1.2,ECDHE-RSA-AES128-GCM-SHA256,2048,128
TLS Server Name:        www.github.com

Document Path:          /
Document Length:        Variable

Concurrency Level:      7
Time taken for tests:   8.636 seconds
Complete requests:      100
Failed requests:        0
Non-2xx responses:      100
Total transferred:      10300 bytes
HTML transferred:       0 bytes
Requests per second:    11.58 [#/sec] (mean)
Time per request:       604.523 [ms] (mean)
Time per request:       86.360 [ms] (mean, across all concurrent requests)
Transfer rate:          1.16 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      428  459  17.7    458     489
Processing:   108  116   5.0    116     135
Waiting:      108  116   4.9    115     133
Total:        536  575  21.5    574     615

Percentage of the requests served within a certain time (ms)
  50%    574
  66%    579
  75%    588
  80%    602
  90%    605
  95%    608
  98%    614
  99%    615
 100%    615 (longest request)
```

**Cloak**
```
Server Software:
Server Hostname:        www.github.com
Server Port:            443
SSL/TLS Protocol:       TLSv1.2,ECDHE-RSA-AES128-GCM-SHA256,2048,128
TLS Server Name:        www.github.com

Document Path:          /
Document Length:        Variable

Concurrency Level:      7
Time taken for tests:   5.628 seconds
Complete requests:      100
Failed requests:        0
Non-2xx responses:      100
Total transferred:      10300 bytes
HTML transferred:       0 bytes
Requests per second:    17.77 [#/sec] (mean)
Time per request:       393.964 [ms] (mean)
Time per request:       56.281 [ms] (mean, across all concurrent requests)
Transfer rate:          1.79 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      246  260  18.8    256     358
Processing:   113  119   3.6    121     129
Waiting:      113  119   3.5    120     127
Total:        361  379  18.4    377     475

Percentage of the requests served within a certain time (ms)
  50%    377
  66%    379
  75%    380
  80%    382
  90%    385
  95%    387
  98%    464
  99%    475
 100%    475 (longest request)
```