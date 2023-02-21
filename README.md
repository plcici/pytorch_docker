# Pytorch Docker

## Docker 启动命令
``` bash
docker run -it --name [name] \
			--tmpfs /tmpfs:rw,exec \
			--gpus all --ipc=host \
			--restart=always \
			-v [your_workspace]:/workspace \
			-p [available_port]:22 \
			pytorch_docker
```
1. `--gpus all` 和 `--ipc=host` 是使用 docker 运行 gpu 的定式
2. `--tmpfs` 用于存放数据库并且进行加速，可选


## How to build ?
在当前目录下执行：
``` bash
docker build -t pytorch_docker .
```