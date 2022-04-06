# target
* Jetson AGX Xavier

# to be introduced
* [TensorRT OSS](https://github.com/NVIDIA/TensorRT) build environment
* [AutoML EfficientDet](https://github.com/google/automl/tree/master/efficientdet) environment
* user `nvidia` and repositories
```
/home/nvidia/TensorRT
/home/nvidia/automl
```

# how to run
1. build docker image
```bash
$ cd /home/nvidia
$ git clone https://github.com/maminus/dockerfiles.git
$ cd dockerfiles/automl_efficientdet_jetpack46
$ docker build -t tensorflow_env .
```

2. run container (mount home directory to `/work`)
```bash
$ docker run -it --name efficientdet --net=host --runtime nvidia -e DISPLAY=$DISPLAY -v ~/:/work -v /tmp/.X11-unix/:/tmp/.X11-unix tensorflow_env
```

3. run script to install remaining libraries
```bash
# in the container
$ su - nvidia
$ bash /work/dockerfiles/automl_efficientdet_jetpack46/additional_install.sh
```

# known issues
* environment variables `OPENBLAS_CORETYPE` and `LANG` are not inherited to user `nvidia`
* because of version dependencies, AutoML code needs modification to train EfficientDet model
```bash
# in the container
$ cd ~/automl/efficientdet

# fix module name conflict
# for more detail, see below
# https://github.com/google/automl/issues/1073#issuecomment-906826397
$ grep -Rl "from keras import" . | xargs sed -i 's/from keras import/from tf2 import/g'
$ git mv keras tf2

# at TensorFlow v2.6, there has not map_vectorization. so comment outed
$ sed -i 's/options.experimental_optimization.map_vectorization/#options.experimental_optimization.map_vectorization/g' dataloader.py
```
