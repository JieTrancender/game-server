# game-server
a game server by using skynet.

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
