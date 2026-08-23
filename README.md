# openwebui-jupyter-code

OpenWebUI **Code Execution / Code Interpreter** 的 Jupyter 服务端后端镜像（数据科学全家桶预装版）。

## 这是什么 / 解决什么问题

OpenWebUI 支持让 AI 在对话中编写并**真实执行 Python 代码**。执行有两条路径：

| 后端 | 位置 | 限制 |
|---|---|---|
| Pyodide（默认） | 浏览器内 WASM | 只能跑固定十几个库；大数据/长任务慢；无法持久安装包 |
| **Jupyter（本仓库）** | 服务端真 Python 内核 | 全库可用、执行快、文件/图表可持久化 |

本项目提供后者：一个基于官方 `quay.io/jupyter/scipy-notebook` 的 Jupyter 容器，**额外预装数据科学、可视化和图像处理常用库**，让 OpenWebUI 的代码执行开箱即用——不再受 Pyodide 的库限制，也不用手动往 Jupyter 里补包。

### 协作流程

```
用户在对话里要求"分析数据并画图"
  → OpenWebUI 模型生成 Python 代码
  → 通过 Jupyter HTTP API（/api/kernels、/api/contents）发送到本容器
  → 在真实 Python 内核中执行（可读挂载目录里的文件、生成图表）
  → 结果/产物回传对话，notebook 与图表保存在 Jupyter 工作区
```

### 预装内容

基于 scipy-notebook 自带栈（numpy / pandas / matplotlib / seaborn / scikit-learn / scipy 等），额外加入：

- **数据读写**：openpyxl, xlsxwriter, pyarrow, fastparquet, beautifulsoup4, lxml, requests
- **可视化**：plotly, pillow, graphviz, pydot
- **统计/建模**：statsmodels
- **图分析**：networkx
- **图像处理**：opencv-python-headless, libgl1, libglib2.0-0
- **其他**：rich

## 快速开始

```bash
cp .env.example .env
# 修改 .env 里的 JUPYTER_TOKEN 为一个随机字符串
docker compose up -d --build
```

- Jupyter Lab: http://localhost:8888 （token 见 .env）
- 工作目录: `./work`（挂载到 `/home/jovyan/work`，AI 生成的文件/图表都在这里）

## 接入 OpenWebUI

1. 启动本服务，记下 Jupyter 地址（如 `http://host.docker.internal:8888` 或 NAS IP）与 token
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

## 部署说明

- 端口映射默认 `8888:8888`，NAS/服务器场景可改成自己的 33xxx 惯例（如 `33024:8888`）
- `docker-compose.yml` 含 `mem_limit: 3g` / `cpus: 2.0` 资源限制，按需调整
- 健康检查会请求 `/api/kernels?token=...`，防止容器"假活"

## License

MIT
