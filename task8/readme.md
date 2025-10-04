#  SSH & Ansible Configuration

how to set up **key-based SSH authentication** and configure **Ansible** to manage remote systems.

---

## Overview

This guide covers:

- Generating an SSH key pair on the control machine  
- Copying the public key to a remote server for passwordless login  
- Creating an Ansible inventory file  
- Testing connectivity with basic Ansible modules

---

## Step 1 — Generate Your SSH Keys

Generate a private/public key pair on the control machine:

```bash
ssh-keygen
```

- Press `Enter` to accept the default location (`~/.ssh/id_rsa`).  
- Optionally enter a passphrase (recommended for extra security) or press `Enter` to skip.

Files created in `~/.ssh/`:

- `id_rsa` — **Private key** (keep secret)  
- `id_rsa.pub` — **Public key** (share with remote servers)

---

## Step 2 — Deploy the Public Key to the Target Server

Use `ssh-copy-id` to copy your public key to the remote server:

```bash
ssh-copy-id user@remote_server_ip
```

For me

```bash
ssh-copy-id dark@10.96.1.236
```

You will be prompted for the remote user’s password one last time. `ssh-copy-id` appends your public key to `~/.ssh/authorized_keys` on the remote server.

---

## Step 3 — Verify Passwordless SSH

Test SSH login:

```bash
ssh user@remote_server_ip
```

If successful, you should log in without entering a password.

---

## Step 4 — Configure the Ansible Inventory

Create an `inventory.ini` file listing the hosts Ansible should manage:

```ini
[servers]
servers ansible_host=10.96.1.236 ansible_user=mahmoud
```

Fields explained:

- `[servers]` — Group name  
- `servers` — Host alias  
- `ansible_host` — Target server IP or hostname  
- `ansible_user` — Remote user Ansible will connect as

---

## Step 5 — Test Ansible Functionality

### Ping Module (connectivity check)

Target all hosts:

```bash
ansible all -i inventory.ini -m ping
```

Target the `servers` group:

```bash
ansible servers -i inventory.ini -m ping
```

Expected success output:

```text
server01 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### Run a Remote Command (example: uptime)

```bash
ansible servers -i inventory.ini -m shell -a "uptime"
```

output:

```text
server01 | CHANGED | rc=0 >>
 14:30:25 up 1 days,  3:42,  1 user,  load average: 0.15, 0.10, 0.08
```

---

## Conclusion


- Created SSH key-based authentication  
- Deployed the public key for passwordless login  
- Built an Ansible inventory file  
- Verified connectivity and remote command execution with Ansible
