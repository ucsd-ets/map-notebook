# 1) choose base container
# generally use the most recent tag

# base notebook, contains Jupyter and relevant tools
# See https://github.com/ucsd-ets/datahub-docker-stack/wiki/Stable-Tag 
# for a list of the most current containers we maintain
ARG BASE_CONTAINER=ghcr.io/ucsd-ets/datascience-notebook:stable
# ARG BASE_CONTAINER=ghcr.io/ucsd-ets/scipy-ml-notebook:2025.2-stable
FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

# 2) change to root to install packages
USER root

#RUN apt-get -y install htop
RUN pip install yolo ultralytics onnxruntime-gpu onnx onnxslim

### Label Studio
ARG ENVNAME=label-studio
ARG PYVER=3.11
RUN mamba create --yes -p "${CONDA_DIR}/envs/${ENVNAME}" \
    python=${PYVER} \
    ipykernel \
    jupyterlab && \
    mamba clean --all -f -y

RUN "${CONDA_DIR}/envs/${ENVNAME}/bin/python" -m ipykernel install --prefix /opt/conda --name="${ENVNAME}" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN "${CONDA_DIR}/envs/${ENVNAME}/bin/pip" install --no-cache-dir \
    label-studio \
    "numpy<2"

### Ultralytics
ARG ENVNAME=ultralytics
ARG PYVER=3.11
RUN mamba create --yes -p "${CONDA_DIR}/envs/${ENVNAME}" \
    python=${PYVER} \
    ipykernel \
    jupyterlab && \
    mamba clean --all -f -y

RUN "${CONDA_DIR}/envs/${ENVNAME}/bin/python" -m ipykernel install --prefix /opt/conda --name="${ENVNAME}" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN conda install -y \
    --prefix /opt/conda --name="${ENVNAME}" \
    -c pytorch -c nvidia -c conda-forge \
    pytorch \
    torchvision \
    pytorch-cuda=11.8 \
    # label-studio \
    "numpy<2" \
    # yolo \
    ultralytics && \ 
    # onnxruntime-gpu \
    # onnx \
    # onnxslim && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN "${CONDA_DIR}/envs/${ENVNAME}/bin/pip" install --no-cache-dir \
    label-studio \
    "numpy<2" \
    yolo \
    onnxruntime-gpu \
    onnx \
    onnxslim && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# 3) install packages using notebook user
USER jovyan

# RUN conda install -y scikit-learn

#RUN pip install --no-cache-dir networkx scipy

# Override command to disable running jupyter notebook at launch
# CMD ["/bin/bash"]
