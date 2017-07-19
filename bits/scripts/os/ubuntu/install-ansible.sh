#!/bin/bash -eux

# Install Ansible repository.
apt-add-repository ppa:ansible/ansible

# Install Ansible.
apt -y update
apt -y install ansible git