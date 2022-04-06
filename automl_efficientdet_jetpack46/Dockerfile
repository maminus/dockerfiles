FROM nvcr.io/nvidia/l4t-base:r32.6.1

RUN apt-get update && apt-get install -y \
    binutils \
    clang-format-6.0 \
    gcc \
    gfortran \
    git \
    hdf5-tools \
    libblas-dev \
    libc6-dev \
    libcurl4-openssl-dev \
    libjpeg8-dev \
    libhdf5-dev \
    libhdf5-serial-dev \
    liblapack-dev \
    libprotobuf-dev \
    libssl-dev \
    make \
    pkg-config \
    protobuf-compiler \
    python3-pip \
    sudo \
    wget \
    zip \
    zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# take care of Illegal instruction
# https://forums.developer.nvidia.com/t/illegal-instruction-core-dumped-xavier/166278/4
ENV OPENBLAS_CORETYPE=ARMV8

RUN python3 -m pip install --upgrade pip \
 && python3 -m pip install testresources \
 && python3 -m pip install --upgrade --no-deps \
    cython \
    future==0.18.2 \
    gast==0.4.0 \
    keras_applications==1.0.8 \
    keras_preprocessing==1.1.2 \
    mock==3.0.5 \
    numpy==1.19.4 \
    protobuf \
    pkgconfig \
    pybind11 \
 && python3 -m pip install \
    Pillow==8.3.2 \
    "pycuda<2021.1" \
    pytest \
    onnx==1.10.0 \
    onnxruntime==1.8.1 \
    torch==1.8.1 \
 && H5PY_SETUP_REQUIRES=0 python3 -m pip install -U h5py==3.1.0 \
 && python3 -m pip install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v46 tensorflow \
 && python3 -m pip cache purge

RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.3/cmake-3.22.3-linux-aarch64.sh \
 && chmod +x ./cmake-*.sh \
 && bash ./cmake-*.sh --prefix=/usr/local --exclude-subdir --skip-license \
 && rm ./cmake-*.sh

ARG uid=1000
ARG gid=1000
RUN groupadd -r -f -g ${gid} nvidia \
 && useradd -o -r -l -u ${uid} -g ${gid} -ms /bin/bash nvidia \
 && usermod -aG sudo nvidia \
 && usermod -aG video nvidia \
 && echo 'nvidia:nvidia' | chpasswd

RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    rsync \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://releases.bazel.build/3.7.2/release/bazel-3.7.2-linux-arm64 \
 && chmod +x bazel-3.7.2-linux-arm64 \
 && mv bazel-3.7.2-linux-arm64 /usr/bin/bazel \
 && cd /usr/bin \
 && rm python \
 && ln -s python3 python

ENV LANG=en_US.UTF-8
