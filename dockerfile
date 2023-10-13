FROM osrf/ros:melodic-desktop-full

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
        software-properties-common \
        build-essential \
        make \
        git \
        vim \
        wget \
        curl \
        gcc \
        zip \
        unzip \
        tar \
        gdb

RUN wget https://github.com/Kitware/CMake/releases/download/v3.10.0/cmake-3.10.0-Linux-x86_64.tar.gz && \
    tar -zxvf cmake-3.10.0-Linux-x86_64.tar.gz && \
    mv cmake-3.10.0-Linux-x86_64 cmake-3.10.0 && \
    ln -sf /cmake-3.10.0/bin/* /usr/bin

### Install Opencv from source ##############
WORKDIR /

RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" && \
    apt-get update && \
    apt-get install -y \
    libgtk2.0-dev \
    pkg-config \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    python-dev \
    python-numpy \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libjasper1 \
    libjasper-dev \
    libdc1394-22-dev

WORKDIR /lib
RUN git clone --branch 4.4.0  --depth 1  https://github.com/opencv/opencv.git && \
    git clone --branch 4.4.0  --depth 1  https://github.com/opencv/opencv_contrib.git

WORKDIR /lib/opencv/
RUN mkdir /lib/opencv/build && \
    cd /lib/opencv/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE -DOPENCV_EXTRA_MODULES_PATH=/lib/opencv_contrib/modules .. && \
    make -j4 && \
    make install

### Install eigen 3 ##############
WORKDIR /
RUN wget https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz
RUN tar -xf eigen-3.4.0.tar.gz && \
    cd /eigen-3.4.0/ && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j4 && \
    make install

### Install Pangolin ##############

WORKDIR /

RUN apt-get install -y \
    libglew-dev \
    libpython2.7-dev \
    libboost-dev \
    libboost-thread-dev \
    libboost-filesystem-dev \
    libx11-dev \
    doxygen \
    doxygen-gui \
    graphviz

WORKDIR /
RUN git clone --depth 1 --branch v0.5 https://github.com/stevenlovegrove/Pangolin.git Pangolin

WORKDIR /Pangolin/
CMD ["/bin/bash", "-c", "'./scripts/install_prerequisites.sh'", "recommended"]
RUN mkdir build && \
    cd build && \
    cmake -DCPP11_NO_BOOSR=1  .. && \
    make -j4 && \
    make install


RUN mkdir -p /orb_slam3/
WORKDIR /orb_slam3/
RUN wget https://svncvpr.in.tum.de/cvpr-ros-pkg/trunk/rgbd_benchmark/rgbd_benchmark_tools/src/rgbd_benchmark_tools/associate.py


CMD ["tail", "-f", "/dev/null"]