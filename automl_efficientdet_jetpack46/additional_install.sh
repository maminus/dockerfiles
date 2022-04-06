#!/bin/bash

cd /home/nvidia

git clone -b main https://github.com/NVIDIA/TensorRT.git
git clone -b v0.14.0 https://github.com/tensorflow/addons.git
git clone -b master https://github.com/tensorflow/hub.git
git clone -b 1.2 https://github.com/google/automl.git


export TF_NEED_CUDA="1"
export TF_CUDA_VERSION="10"
export TF_CUDNN_VERSION="8"
export CUDA_TOOLKIT_PATH="/usr/local/cuda"
export CUDNN_INSTALL_PATH="/usr/lib/aarch64-linux-gnu"
export PATH=${PATH}:/usr/local/cuda/bin

cd /home/nvidia/addons
python3 ./configure.py
bazel build build_pip_pkg
bazel-bin/build_pip_pkg artifacts

cd /home/nvidia/hub
bazel build tensorflow_hub/pip_package:build_pip_package
bazel-bin/tensorflow_hub/pip_package/build_pip_package /home/nvidia/hub/artifacts

bazel clean
rm -rf /home/nvidia/.cache/bazel



sudo python3 -m pip install -r /home/nvidia/TensorRT/samples/python/efficientdet/requirements.txt
sudo python3 -m pip install onnx_graphsurgeon --index-url https://pypi.ngc.nvidia.com
sudo python3 -m pip install /home/nvidia/addons/artifacts/tensorflow_addons-*.whl
sudo python3 -m pip install /home/nvidia/hub/artifacts/tensorflow_hub-*.whl
sudo python3 -m pip install -r /home/nvidia/automl/efficientdet/requirements.txt

rm -rf /home/nvidia/addons
rm -rf /home/nvidia/hub
