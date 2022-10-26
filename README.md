# game-server
该项目是工作几年有关线上skynet项目的实践总结。

#### etcd 本地集群
推荐使用[goreman](https://github.com/mattn/goreman)进程管理工具，可以快速创建、停止本地的多节点etcd集群可以通过`go install github.com/mattn/goreman@latest`快速安装goreman。然后从[etcd release](https://github.com/etcd-io/etcd/releases/v3.4.9)下载etcd v3.4.9二进制文件，再从[etcd源码](https://github.com/etcd-io/etcd/blob/v3.4.9/Procfile)中下载goreman Procfile文件，它描述了etcd进程名、节点数、参数等信息。最后通过goreman -f Procfile start命令就可以快速启动一个3节点的本地集群了。为了方便已经下载保存到scripts/etcd-procfile文件了。

#### docker方式启动
~~~
docker build -t game-server .
docker run --rm -it --name game-server-test game-server ./skynet/skynet examples/config.helloWorld.lua
~~~

#### 本地开发
~~~
docker build -t game-server .
sh tools/container.sh
~~~

#### 火焰图
**本地开发**模式进入容器，执行`./skynet/skynet examples/config.testprofile.lua`测试。

浏览器访问`http://127.0.0.1:11001/admin#/dashboard`输入节点地址`127.0.0.1:11002`提交。点击左侧**profiler**栏，再点击开启开始测试，完毕后查看`snlua service_cell cost_cpu`服务的CPU和MEM火焰图。

#### TODO
架构、优化等更多内容逐步到来，欢迎关注该项目。
与此相关博客`https://www.keyboard-man.com/categories/skynet/`。
