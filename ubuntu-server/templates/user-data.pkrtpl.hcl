#cloud-config
autoinstall:
  version: 1

  source:
    id: ubuntu-server-minimal

  identity:
    hostname: ${hostname}
    username: ${username}
    password: ${encrypted_password}

  ssh:
    install-server: true
    allow-pw: true
    authorized-keys:
      - ${ssh_key}

  user-data:
    users:
      - name: ${username}
        sudo: ALL=(ALL) NOPASSWD:ALL

  updates: all
