#!/bin/bash -eux

# Update and upgrade all packages
apt -y update && apt-get -y upgrade

# Bring in software-properties-common
apt -y install software-properties-common
