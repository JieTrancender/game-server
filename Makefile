.PHONY : etcd

etcd :
	@etcd --config-file conf/etcd-cluster/etcd1.conf 2>&1 >/dev/null &
	@etcd --config-file conf/etcd-cluster/etcd2.conf 2>&1 >/dev/null &
	@etcd --config-file conf/etcd-cluster/etcd3.conf 2>&1 >/dev/null &

	@sleep 3s
	@sh scripts/init_etcd.sh
