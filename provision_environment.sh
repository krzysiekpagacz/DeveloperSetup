#!/bin/bash

set -euo pipefail

export ANSIBLE_CONFIG=./ansible/ansible.cfg

force_unlock_apt() {
  local pids

  pids="$({ sudo fuser /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/lib/apt/lists/lock /var/cache/apt/archives/lock 2>/dev/null || true; } | tr -s ' ' '\n' | awk 'NF')"

  if [[ -n "$pids" ]]; then
    echo "forcing apt/dpkg unlock (killing lock holder processes: ${pids//$'\n'/ }) ......."
    echo "$pids" | xargs -r sudo kill -TERM || true
    sleep 1
    echo "$pids" | xargs -r sudo kill -KILL || true
  fi

  sudo rm -f /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/lib/apt/lists/lock /var/cache/apt/archives/lock
  sudo dpkg --configure -a >/dev/null 2>&1 || true
}

apt_update_quiet() {
  force_unlock_apt
  sudo apt-get update -qq
}

apt_install_quiet() {
  force_unlock_apt
  sudo apt-get install -qq --yes "$@"
}

ensure_ansible_ppa() {
  if grep -Rqs "ppa.launchpadcontent.net/ansible/ansible/ubuntu" /etc/apt/sources.list /etc/apt/sources.list.d; then
    echo "ansible ppa already configured"
  else
    force_unlock_apt
    sudo add-apt-repository --yes ppa:ansible/ansible
  fi
}

echo "Start initial setup ......."

if ! command -v ansible-playbook &> /dev/null; then
  echo "ansible not found, installing ......."
  ensure_ansible_ppa
  apt_update_quiet
  apt_install_quiet ansible
else
  echo "checking ansible version from apt ......."
  ensure_ansible_ppa
  apt_update_quiet

  installed_ansible_version=""
  if dpkg-query -W ansible &> /dev/null; then
    installed_ansible_version="$(dpkg-query -W -f='${Version}' ansible)"
  fi

  candidate_ansible_version="$(apt-cache policy ansible | awk '/Candidate:/ {print $2}')"

  if [[ -z "$installed_ansible_version" ]]; then
    echo "ansible package is not managed by apt, installing apt ansible ......."
    apt_install_quiet ansible
  elif [[ -n "$candidate_ansible_version" ]] && [[ "$candidate_ansible_version" != "(none)" ]] && dpkg --compare-versions "$installed_ansible_version" lt "$candidate_ansible_version"; then
    echo "updating ansible from ${installed_ansible_version} to ${candidate_ansible_version} ......."
    apt_install_quiet --only-upgrade ansible
  else
    echo "ansible is up to date (${installed_ansible_version})"
  fi
fi

##############################
# install ansible requirements
##############################
rm -rf ~/.ansible/roles && rm -rf ~/.ansible_collections
ansible-galaxy install --role-file=./ansible/ansible_requirements.yaml --roles-path=~/.ansible/roles --force

##############################
ansible-playbook --connection=local --inventory=127.0.0.1, --extra-vars "@vars.yaml" ./ansible/ansible_root_playbook.yaml --ask-become-pass
