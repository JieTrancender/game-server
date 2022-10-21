# game-server
a game server by using skynet.

#### etcd 本地集群
推荐使用[goreman](https://github.com/mattn/goreman)进程管理工具，可以快速创建、停止本地的多节点etcd集群可以通过`go install github.com/mattn/goreman@latest`快速安装goreman。然后从[etcd release](https://github.com/etcd-io/etcd/releases/v3.4.9)下载etcd v3.4.9二进制文件，再从[etcd源码](https://github.com/etcd-io/etcd/blob/v3.4.9/Procfile)中下载goreman Procfile文件，它描述了etcd进程名、节点数、参数等信息。最后通过goreman -f Procfile start命令就可以快速启动一个3节点的本地集群了。为了方便已经下载保存到scripts/etcd-procfile文件了。

#### docker方式启动
~~~
docker build -t skynet-etcd .
docker run --rm -it --name game-server-test game-server ./skynet/skynet examples/config.helloWorld.lua
~~~

#### 本地开发
~~~
docker build -t skynet-etcd .
sh tools/container.sh
~~~
