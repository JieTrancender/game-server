etcdctl --endpoints 127.0.0.1:2379,127.0.0.1:2381,127.0.0.1:2383 endpoint health
etcdctl --endpoints 127.0.0.1:2379,127.0.0.1:2381,127.0.0.1:2383 user add root --new-user-password=123456
etcdctl --endpoints 127.0.0.1:2379,127.0.0.1:2381,127.0.0.1:2383 role add root
etcdctl --endpoints 127.0.0.1:2379,127.0.0.1:2381,127.0.0.1:2383 role grant-permission root readwrite /
etcdctl --endpoints 127.0.0.1:2379,127.0.0.1:2381,127.0.0.1:2383 user grant-role root root
etcdctl --endpoints 127.0.0.1:2379,127.0.0.1:2381,127.0.0.1:2383 auth enable
etcdctl --endpoints 127.0.0.1:2379,127.0.0.1:2381,127.0.0.1:2383 --user root --password 123456  put /test {\"message\":\"test\"}
etcdctl --endpoints 127.0.0.1:2379,127.0.0.1:2381,127.0.0.1:2383 --user root --password 123456  get /test
