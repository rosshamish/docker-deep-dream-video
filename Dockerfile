# Borrowed/stolen originally from https://github.com/ryankennedyio/deep-dream-generator

FROM ipython/ipython:3.x

MAINTAINER Ross Anderson <ross.anderson87@gmail.com>

RUN apt-get update

RUN apt-get install -y wget

# Fetch & install Anaconda
RUN wget http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-2.0.1-Linux-x86_64.sh && bash Anaconda-2.0.1-Linux-x86_64.sh -b

# Set Anaconda's path
ENV PATH=/root/anaconda/bin:$PATH
RUN yes | conda update conda 

#Install caffe deep learning dependancies
RUN apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev libhdf5-serial-dev

RUN easy_install protobuf

#Install remaining deep learning dependancies
RUN apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler
RUN apt-get install -y libjpeg-dev
RUN apt-get install -y libjpeg62

#Install atlas
RUN apt-get install -y libatlas-base-dev

# Install DeepDreamVideo deps
RUN sudo apt-get install -y python-software-properties software-properties-common
RUN sudo add-apt-repository ppa:mc3man/trusty-media
RUN sudo apt-get update
RUN sudo apt-get -y dist-upgrade
RUN sudo apt-get install -y ffmpeg

# Ensure that the Nvidia kernel module and CUDA drivers are installed
# https://github.com/tleyden/docker/blob/master/ubuntu-cuda/Dockerfile

ENV CUDA_RUN http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.14_linux_64.run

RUN apt-get update && apt-get install -q -y \
  wget \
  build-essential 

RUN cd /opt && \
  wget $CUDA_RUN && \
  chmod +x *.run && \
  mkdir nvidia_installers && \
  ./cuda_6.5.14_linux_64.run -extract=`pwd`/nvidia_installers && \
  cd nvidia_installers && \
  ./NVIDIA-Linux-x86_64-340.29.run -s -N --no-kernel-module

RUN cd /opt/nvidia_installers && \
  ./cuda-linux64-rel-6.5.14-18749181.run -noprompt

# Ensure the CUDA libs and binaries are in the correct environment variables
ENV LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-6.5/lib64
ENV PATH=$PATH:/usr/local/cuda-6.5/bin

### END CUDA

# Install Caffe
ADD caffe-master /caffe-master

RUN cd /caffe-master && make all -j8
RUN cd /caffe-master && make distribute

ADD models /models

# Set caffe to be in the python path
ENV PYTHONPATH=/caffe-master/distribute/python
ENV PATH $PATH:/opt/caffe/.build_release/tools

# Add ld-so.conf so it can find libcaffe.so
ADD caffe-ld-so.conf /etc/ld.so.conf.d/

# Run ldconfig again (not sure if needed)
RUN ldconfig
