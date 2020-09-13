#!/usr/bin/env bash

# All stdout/stderr should be redirected to log file by caller

cd /root/source || {
  echo "Could not enter /root/source; aborting"
  exit 1
}

ansible-playbook -i localhost ./configure/ansible/main.yaml
