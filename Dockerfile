FROM ubuntu:14.04

RUN apt-get update && apt-get install -y wget vim
RUN wget https://packages.chef.io/stable/ubuntu/12.04/chefdk_0.19.6-1_amd64.deb
RUN dpkg -i chefdk_0.19.6-1_amd64.deb

ADD . /my-dev-box
RUN cd /my-dev-box && chef-solo -c solo.rb -j attributes.json

WORKDIR /my-dev-box
