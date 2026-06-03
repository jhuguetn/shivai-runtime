FROM python:3.11.13-slim-bullseye

ARG SHIVAI_COMMIT=b57c49175861b9a434e6b8bc3b0491faf4a0aac9
ARG ANTS_VERSION=2.4.3
ARG TENSORFLOW_VERSION=2.17.0
ARG KERAS_VERSION=3.6.0

LABEL org.opencontainers.image.title="shivai-runtime" \
      org.opencontainers.image.description="Portable CPU-only Docker runtime for reproducible SHiVAi execution" \
      org.opencontainers.image.authors="jhuguet@barcelonabeta.org" \
      org.opencontainers.image.source="https://github.com/pboutinaud/SHiVAi" \
      org.opencontainers.image.version="${SHIVAI_COMMIT}"

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    TF_CPP_MIN_LOG_LEVEL=2 \
    CUDA_VISIBLE_DEVICES=-1 \
    ANTSPATH=/opt/ants-2.4.3/bin \
    PATH=/opt/ants-2.4.3/bin:${PATH} \
    SHIVAI_VERSION=${SHIVAI_COMMIT}
# Conservative CPU/threading defaults
# ENV ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=4 \
#     OMP_NUM_THREADS=4 \
#     OPENBLAS_NUM_THREADS=4 \
#     MKL_NUM_THREADS=4 \
#     NUMEXPR_NUM_THREADS=4

# System dependencies: minimal set required by SHiVAi
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    wget \
    unzip \
    libcairo2 \
    libgdk-pixbuf2.0-0 \
    libpango-1.0-0 \
    libpangoft2-1.0-0 \
    libffi-dev \
    libjpeg-dev \
    libopenjp2-7-dev \
    graphviz \
    && rm -rf /var/lib/apt/lists/*

# ANTs
WORKDIR /opt
RUN wget -q https://github.com/ANTsX/ANTs/releases/download/v${ANTS_VERSION}/ants-${ANTS_VERSION}-ubuntu-20.04-X64-gcc.zip && \
    unzip ants-${ANTS_VERSION}-ubuntu-20.04-X64-gcc.zip && \
    rm ants-${ANTS_VERSION}-ubuntu-20.04-X64-gcc.zip

# niimath
WORKDIR /usr/local/bin
RUN wget -q https://github.com/rordenlab/niimath/releases/latest/download/niimath_lnx.zip && \
    unzip niimath_lnx.zip && \
    rm niimath_lnx.zip

# dcm2niix
RUN wget -q https://github.com/rordenlab/dcm2niix/releases/latest/download/dcm2niix_lnx.zip && \
    unzip dcm2niix_lnx.zip && \
    rm dcm2niix_lnx.zip

# SHiVAi install (pinned source)
WORKDIR /usr/local/src
RUN git clone https://github.com/pboutinaud/SHiVAi.git shivai && \
    cd shivai && \
    git checkout ${SHIVAI_COMMIT}

WORKDIR /usr/local/src/shivai
RUN python -m pip install --upgrade pip setuptools wheel build && \
    python -m pip install  \
        tensorflow==${TENSORFLOW_VERSION}  \
        keras==${KERAS_VERSION} && \
    python -m pip install . && \
    rm -rf /usr/local/src/shivai

WORKDIR /tmp

ENTRYPOINT ["shiva"]
