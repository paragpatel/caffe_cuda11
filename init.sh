#!/bin/sh
cd $CAFFE_ROOT
CAFFE_LIBFILE=build/lib/_caffe.so
if [ -f "$CAFFE_LIBFILE" ]; then
        echo "caffe found !!"
else
        mkdir build && cd build && cmake -DUSE_CUDNN=1 -Dpython_version=3 .. && make -j"$(nproc)" && cd ..
fi
echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig
cd /workspace
bash
