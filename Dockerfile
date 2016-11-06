FROM ubuntu:14.04

RUN apt-get update && apt-get install wget
RUN wget https://packages.chef.io/stable/ubuntu/12.04/chefdk_0.19.6-1_amd64.deb
RUN dpkg -i chefdk_0.19.6-1_amd64.deb
WORKSPACE /my-dev-box
RUN chef-solo -c solo.rb -j attributes.json
