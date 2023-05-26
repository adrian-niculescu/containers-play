#!/bin/bash

bash stop.sh
sudo docker build -t docker-node-hello-world .
sudo docker container run -d --name node1 docker-node-hello-world