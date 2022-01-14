#!/bin/bash
# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
sleep 1
done
// install nginx
sudo apt-get update
apt-get -y install nginx
service nginx resart