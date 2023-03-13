FROM nvidia/cuda:11.4.1-cudnn8-devel-ubuntu20.04
LABEL maintainer caffe-maint@googlegroups.com
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        protobuf-compiler \
        python3-dev \
        python3-numpy \
        python3-pip \
        python3-setuptools \
        python3-scipy \
        python-is-python3 && \
    rm -rf /var/lib/apt/lists/*
COPY init.sh /init.sh
ENV CAFFE_ROOT=/opt/caffe
WORKDIR $CAFFE_ROOT

ENV CLONE_TAG=fixes_for_cudnn8_bvlc_master

#RUN git clone -b ${CLONE_TAG} --depth 1 https://github.com/paragpatel/caffe.git . && \
#    pip install --upgrade pip && \
#    cd python && for req in $(cat requirements.txt) pydot; do pip install $req; done && cd .. && \
#    git clone https://github.com/NVIDIA/nccl.git && cd nccl && make -j install && cd .. && rm -rf nccl && \
#    mkdir build && cd build && \
#    cmake -DUSE_CUDNN=1 -DUSE_NCCL=1 .. && \
#    make -j"$(nproc)"

RUN git clone -b ${CLONE_TAG} --depth 1 https://github.com/paragpatel/caffe.git . && \
    pip3 install --upgrade pip && \
    cd python && for req in $(cat requirements.txt) pydot 'python-dateutil>2'; do pip3 install $req; done && cd ..

RUN apt-get update && apt-get install protobuf-compiler libprotobuf-dev libsnappy-dev
#ref: https://github.com/protocolbuffers/protobuf/issues/10158
RUN pip3 install --user protobuf==3.20.1 grpcio==1.46.0 grpcio-tools==1.46.0
#RUN  mkdir build && cd build && \
#    cmake -DUSE_CUDNN=1 -Dpython_version=3 .. && \
#    make -j"$(nproc)"

ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig
#RUN pip uninstall -y protobuf
#RUN pip install --no-binary protobuf protobuf
WORKDIR /workspace
ENTRYPOINT ["sh","/init.sh"]
