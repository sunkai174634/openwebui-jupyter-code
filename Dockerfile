FROM quay.io/jupyter/scipy-notebook:latest

# Optional mirror overrides for building behind slow/throttled networks
# (e.g. in CN). Leave empty to use the official upstreams.
#   docker build --build-arg APT_MIRROR=https://mirrors.aliyun.com/ubuntu/ \
#                --build-arg PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple .
ARG APT_MIRROR=""
ARG PIP_INDEX_URL=""

USER root

# Keep apt layer small; most scientific Python stack is already in scipy-notebook.
RUN if [ -n "$APT_MIRROR" ]; then \
      sed -i "s|http://archive.ubuntu.com/ubuntu|${APT_MIRROR}|g" \
        /etc/apt/sources.list /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources 2>/dev/null || true; \
    fi \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       graphviz \
       libgl1 \
       libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

RUN python -m pip install --no-cache-dir --index-url "${PIP_INDEX_URL:-https://pypi.org/simple}" \
    openpyxl \
    xlsxwriter \
    pyarrow \
    fastparquet \
    plotly \
    pillow \
    opencv-python-headless \
    beautifulsoup4 \
    lxml \
    requests \
    statsmodels \
    networkx \
    pydot \
    rich

WORKDIR /home/jovyan/work
