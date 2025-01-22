#!/bin/bash

# Update and install required packages
sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3-pip
sudo DEBIAN_FRONTEND=noninteractive apt install -y python3-virtualenv

# Set proper ownership
chown -R ubuntu:ubuntu ~

# Install and set up Python virtual environment
virtualenv venv

# Activate virtual environment and install Flask
. venv/bin/activate
pip3 install flask

# Show Flask installation details for verification
pip3 show flask

# Run Flask app in the background
nohup python3 app.py > app.log 2>&1 &

# Confirm the app is running
echo "Flask app started in background"
ps -ef | grep python
