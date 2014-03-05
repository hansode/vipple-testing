Scenario: VIP Failover
======================

Setup
-----

```
$ time vagrant up
```

System Configuration Diagram
----------------------------

```
        +------+
        | host |
        +------+
           |
         (ssh)
           |
     +-----+-----+
     |           |
 +---|--+    +---|--+
 |   V  |    |   V  |
 | eth0 |    | eth0 |
 |      |    |      |
 |      |    |      |
 | eth1<-----> eth1 |  vip failover line
 |      |    |      |
 +------+    +------+
  node01      node02
```

Failover Tests
==============

| filename policy     | test target                |
|:--------------------|:---------------------------|
| failover-test_0*.sh | `vipple`                   |
| failover-test_1*.sh | `vipple-zero`              |
| failover-test_2*.sh | `vipple` and `vipple-zero` |

Run tests
---------

```
$ time ./run-tests.sh
```

```
+ force_stop_vipple node01
+ local node=node01
+ vagrant ssh node01 -c 'sudo service vipple stop || :'
Stopping simple virtual ip address handler: RTNETLINK answers: Cannot assign requested address
[FAILED]
+ force_stop_vipple node02
+ local node=node02
+ vagrant ssh node02 -c 'sudo service vipple stop || :'
Stopping simple virtual ip address handler: RTNETLINK answers: Cannot assign requested address
[FAILED]
+ start_vipple node01
+ local node=node01
+ vagrant ssh node01 -c 'sudo service vipple start'
Starting simple virtual ip address handler: PING 10.126.5.17 (10.126.5.17) 56(84) bytes of data.

--- 10.126.5.17 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 3003ms
pipe 3
[  OK  ]
+ show_ipaddr node01
+ local node=node01
+ vagrant ssh node01 -c 'ip addr show eth1 | grep -w inet'
    inet 10.126.5.18/24 brd 10.126.5.255 scope global eth1
    inet 10.126.5.17/24 scope global secondary eth1
+ stop_vipple node01
+ local node=node01
+ vagrant ssh node01 -c 'sudo service vipple stop'
Stopping simple virtual ip address handler: [  OK  ]
+ start_vipple node02
+ local node=node02
+ vagrant ssh node02 -c 'sudo service vipple start'
Starting simple virtual ip address handler: PING 10.126.5.17 (10.126.5.17) 56(84) bytes of data.

--- 10.126.5.17 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 3002ms
pipe 3
[  OK  ]
+ show_ipaddr node02
+ local node=node02
+ vagrant ssh node02 -c 'ip addr show eth1 | grep -w inet'
    inet 10.126.5.19/24 brd 10.126.5.255 scope global eth1
    inet 10.126.5.17/24 scope global secondary eth1
+ stop_vipple node02
+ local node=node02
+ vagrant ssh node02 -c 'sudo service vipple stop'
Stopping simple virtual ip address handler: [  OK  ]

real    0m46.967s
user    0m0.937s
sys     0m6.507s
```
