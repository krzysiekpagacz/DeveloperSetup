#!/bin/bash

set -euo pipefail

export ANSIBLE_CONFIG=./ansible/ansible.cfg

echo "Start initial setup ......."

#sudo add-apt-repository --yes ppa:ansible/ansible
#sudo apt-get update -qq
#sudo apt-get install -qq --yes ansible python3-keyring

##############################
# install ansible requirements
##############################
rm -rf ~/.ansible/roles && rm -rf ~/.ansible_collections
ansible-galaxy install --role-file=./ansible/ansible_requirements.yaml --roles-path=~/.ansible/roles --force

##############################
ansible-playbook --connection=local --inventory=127.0.0.1, --extra-vars "@vars.yaml" ./ansible/ansible_root_playbook.yaml --ask-become-pass
