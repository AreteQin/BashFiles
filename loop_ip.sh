#! /bin/bash

for ip in $(seq 200 255); do

ping -c 1 192.168.1.$ip

done