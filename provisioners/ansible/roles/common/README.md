# goldimages_common

Simplified `common` role for GoldImages.

## What changed

- removed the large per-distro `vars/` matrix
- removed unused distro-specific task files
- consolidated package selection into one small map keyed by `os_family`
- kept only the baseline concerns: packages, users, ssh, motd, ps1, sysctl
- fixed copy destinations, ownership, and modes so the role is lint-friendly

## Layout

```text
roles/common/
├── defaults/main.yml
├── files/ps1.sh
├── handlers/main.yml
├── meta/main.yml
├── tasks/
│   ├── main.yml
│   ├── motd.yml
│   ├── packages.yml
│   ├── ps1.yml
│   ├── ssh.yml
│   ├── sysctl.yml
│   └── users.yml
└── templates/motd.j2
```

## Example playbook

```yaml
---
- name: Configure base image
  hosts: all
  become: true
  gather_facts: true
  roles:
    - role: common
      vars:
        common_packages:
          - vim
          - curl
          - bash-completion
```

## Notes

- Keep the base package list conservative for image portability.
- Add profile-specific packages in separate roles such as `docker`, `k8s_node`, `oracle`, or `samba`.
- If you want `htop` or `cowsay` on EL, enable EPEL in a dedicated profile role instead of the base role.
