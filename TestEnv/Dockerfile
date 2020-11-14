FROM ubuntu:20.04

### Install minimal additional packages to test lib
RUN apt-get update

RUN apt-get install -y --allow-unauthenticated ansible tree nano sudo git

RUN apt-get clean

### Create test user with sudo rights (no password)
RUN useradd -ms /bin/bash testuser
RUN echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

### Set default work environment when connecting to docker
USER testuser
WORKDIR /home/testuser

