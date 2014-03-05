Scenario: VIP Failover
======================

Setup
-----

```
$ time vagrant up
```

Failover Tests
==============

Run tests
---------

```
$ time ./run-tests.sh
```

Senario Testing
---------------

| filename policy     | test target                |
|:--------------------|:---------------------------|
| failover-test_0*.sh | `vipple`                   |
| failover-test_1*.sh | `vipple-zero`              |
| failover-test_2*.sh | `vipple` and `vipple-zero` |
