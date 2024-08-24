#cloud-config
users:
  - name: ${user}
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    # ssh-authorized-keys:
    #   - ${file("~/.ssh/id_rsa.pub")}