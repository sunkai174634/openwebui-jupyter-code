# openwebui-jupyter-code

OpenWebUI Code Execution / Code Interpreter 的 Jupyter 后端镜像（带数据科学全家桶）。

基于官方 `quay.io/jupyter/scipy-notebook`，额外预装：openpyxl, xlsxwriter, pyarrow, fastparquet, plotly, pillow, opencv-python-headless, beautifulsoup4, lxml, requests, statsmodels, networkx, pydot, rich，以及系统包 graphviz / libgl1 / libglib2.0-0。

> OpenWebUI 官方文档用裸 `jupyter/minimal-notebook`，本仓库在官方基础上补齐了数据分析/可视化/图像处理的常用库，开箱即用。

## 快速开始

```bash
cp .env.example .env
# 修改 .env 里的 JUPYTER_TOKEN 为一个随机字符串
docker compose up -d --build
```

- Jupyter Lab: http://localhost:8888 （token 见 .env）
- 工作目录: `./work`（挂载到 `/home/jovyan/work`）

## 接入 OpenWebUI

1. 启动本服务，记下 Jupyter URL（如 `http://host.docker.internal:8888` 或 NAS 地址）与 token
2. OpenWebUI → Admin Panel → Settings → Code Execution，配置：

```env
CODE_EXECUTION_ENGINE=jupyter
CODE_EXECUTION_JUPYTER_URL=http://<jupyter-host>:8888
CODE_EXECUTION_JUPYTER_AUTH=token
CODE_EXECUTION_JUPYTER_AUTH_TOKEN=<your-token>
CODE_EXECUTION_JUPYTER_TIMEOUT=60
```

（Code Interpreter 同名变量同理，`CODE_INTERPRETER_*`）

参考官方教程：https://docs.openwebui.com/tutorials/integrations/dev-tools/jupyter

## 说明

- 端口映射默认 `8888:8888`，NAs/服务器场景可改成自己的 33xxx 惯例（如 `33024:8888`）
- `docker-compose.yml` 里有 `mem_limit: 3g` / `cpus: 2.0` 资源限制，按需调整
- 健康检查会请求 `/api/kernels?token=...`，防止容器"假活"

## License

MIT
