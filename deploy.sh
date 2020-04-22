#!/bin/bash
# Build images
docker build  -t hoesslj/multi-client:latest -t hoesslj/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build  -t hoesslj/multi-server:latest -t hoesslj/multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build  -t hoesslj/multi-worker:latest -t hoesslj/multi-worker:$GIT_SHA -f ./server/Dockerfile ./worker

# Push to dockerhub
docker push hoesslj/multi-client:latest
docker push hoesslj/multi-server:latest
docker push hoesslj/multi-worker:latest
docker push hoesslj/multi-client:$GIT_SHA
docker push hoesslj/multi-server:$GIT_SHA
docker push hoesslj/multi-worker:$GIT_SHA

# Apply the kubernetes files [we setup the google-cloud sdk cli already]
kubectl apply -f k8s

# Make sure we use the latest image of 
kubectl set image deployments/server-deployment server=hoesslj/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment server=hoesslj/multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment server=hoesslj/multi-worker:$GIT_SHA