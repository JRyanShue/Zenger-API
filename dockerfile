# used to be ubuntu 18.04
FROM ubuntu:18.04
RUN apt-get -y update
RUN apt-get -y install git wget autoconf automake libtool curl make g++ unzip cmake python3 python3-dev python3-sip-dev python3-pip
# for libArcus
RUN apt-get -y install nodejs build-essential protobuf-compiler libprotoc-dev libprotobuf-dev
# RUN apt-get -y install build-essentials cmake python3-dev python3-sip-dev protobuf-compiler libprotoc-dev libprotobuf-dev

RUN wget https://github.com/google/protobuf/releases/download/v3.5.0/protobuf-all-3.5.0.zip

RUN git clone https://github.com/Ultimaker/libArcus.git

# install protobuf
RUN unzip protobuf-all-3.5.0.zip
WORKDIR "/protobuf-3.5.0"
RUN ./autogen.sh 
RUN ./configure 
RUN make
RUN make install
RUN ldconfig

# install libArcus
WORKDIR "/libArcus"
RUN git pull
RUN git checkout 4.4
RUN mkdir build && cd build && cmake .. && make -j4 && make install

# Pull zengerengine code from Github (lower than other operations because it will be modified)
WORKDIR "/"
RUN git clone https://github.com/JRyanShue/ZengerEngine.git

# install zengerengine
WORKDIR "/ZengerEngine"
# RUN git pull
# RUN git checkout
RUN mkdir build && cd build && cmake .. && make

# C++ portion installation done
# Get the required base resources for slicing
WORKDIR /app
RUN git clone https://github.com/JRyanShue/ZengerEngine-Presets.git
RUN cd ZengerEngine-Presets && git pull

WORKDIR /app
RUN git clone https://github.com/JRyanShue/Test-STLs.git
RUN cd Test-STLs && git pull

# Specify the command to run on container start
WORKDIR /app
# To hold file uploads, etc:
RUN mkdir resources

# insert python and other scripts within the same working directory, install dependencies
WORKDIR /app
# Copy requirements.txt into the directory and install requirements
RUN wget https://raw.githubusercontent.com/JRyanShue/ZengerCuraEngine-in-the-Air/master/requirements.txt
RUN pip3 install -r requirements.txt

RUN apt-get install curl

RUN npm install webpack webpack-cli --save-dev
RUN npm install react react-dom
RUN npm install -D babel-loader @babel/core @babel/preset-react
RUN npm install -g yarn
RUN yarn global add create-react-app react-scripts-cssmodules
RUN npx create-react-app frontend



# Get the web app files (and central application)
RUN git clone https://github.com/JRyanShue/ZengerCuraEngine-in-the-Air.git #saaaaaaaaaaaaaaaaaaaaaaaaaa
RUN cd ZengerCuraEngine-in-the-Air && git pull

CMD [ "python3", "./ZengerCuraEngine-in-the-Air/main.py" ]

# Set base image (host OS) <- this used to be at the beginning of the python stuff
# FROM python:3.8-alpine

# By default, listen on port 5000 <- used to be right after setting base image
# EXPOSE 5000/tcp
