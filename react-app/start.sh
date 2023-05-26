#!/bin/bash

bash stop.sh
sudo docker build -t react-app .
sudo docker container run -d --name react1 react-app