FROM quay.io/jupyter/scipy-notebook:latest

USER root

# Keep apt layer small; most scientific Python stack is already in scipy-notebook.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       graphviz \
       libgl1 \
       libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

RUN python -m pip install --no-cache-dir \
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
