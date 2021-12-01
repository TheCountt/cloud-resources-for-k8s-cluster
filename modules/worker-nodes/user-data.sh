#!/bin/bash
for i in 0 1 2 
do
name="worker-${i}|pod-cidr=172.20.${i}.0/24"
done