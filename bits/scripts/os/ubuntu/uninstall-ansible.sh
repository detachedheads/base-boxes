#!/bin/bash -eux

# Uninstall Ansible and remove PPA.
apt -y remove --purge ansible git
apt-add-repository --remove ppa:ansible/ansible

# Remove temporary files
rm -rf /root/.ansible
rm -rf /root/.ansible_galaxy