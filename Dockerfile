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

# Install Caffe
ADD caffe-master /caffe-master

RUN cd /caffe-master && make && make distribute

ADD models /models

# Set caffe to be in the python path
ENV PYTHONPATH=/caffe-master/distribute/python
ENV PATH $PATH:/opt/caffe/.build_release/tools

# Add ld-so.conf so it can find libcaffe.so
ADD caffe-ld-so.conf /etc/ld.so.conf.d/

# Run ldconfig again (not sure if needed)
RUN ldconfig
