Scenario: VIP Failover
======================

Setup
-----

```
$ time vagrant up
```

Failover Tests
==============

Prepare
-------

Terminal-A:

```
$ vagrant ssh node01
$ tail -F /var/log/messages
```

Terminal-B:

```
$ vagrant ssh node02
$ tail -F /var/log/messages
```

Run tests
---------

```
$ time ./failover-test.sh
```

```
+ force_stop_vipple node01
+ local node=node01
+ vagrant ssh node01 -c 'sudo /etc/init.d/vipple stop || :'
Stopping simple virtual ip address handler: RTNETLINK answers: Cannot assign requested address
[FAILED]
+ force_stop_vipple node02
+ local node=node02
+ vagrant ssh node02 -c 'sudo /etc/init.d/vipple stop || :'
Stopping simple virtual ip address handler: RTNETLINK answers: Cannot assign requested address
[FAILED]
+ start_vipple node01
+ local node=node01
+ vagrant ssh node01 -c 'sudo /etc/init.d/vipple start'
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
+ vagrant ssh node01 -c 'sudo /etc/init.d/vipple stop'
Stopping simple virtual ip address handler: [  OK  ]
+ start_vipple node02
+ local node=node02
+ vagrant ssh node02 -c 'sudo /etc/init.d/vipple start'
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
+ vagrant ssh node02 -c 'sudo /etc/init.d/vipple stop'
Stopping simple virtual ip address handler: [  OK  ]

real    0m46.967s
user    0m0.937s
sys     0m6.507s
```
