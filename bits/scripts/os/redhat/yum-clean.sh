#!/bin/bash -eux 

# Remove yum leaves
yum -y remove $(package-cleanup --quiet --leaves --exclude-bin) || true

# Clean cache
yum clean all
