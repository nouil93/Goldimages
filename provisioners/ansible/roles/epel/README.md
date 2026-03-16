# Ansible Role: epel

Installs and manages the **EPEL (Extra Packages for Enterprise Linux)** repository
on Red Hat Enterprise Linux and compatible distributions.

This role is designed for automated infrastructure builds such as
**Goldimage pipelines**, CI environments, and hardened server deployments.

---

## Supported Platforms

| Distribution | Versions |
|---|---|
| Rocky Linux | 8, 9 |
| AlmaLinux | 8, 9 |
| RHEL | 8, 9 |
| CentOS Stream | 8, 9 |

---

## Role Philosophy

This role follows Goldimage principles:

- Idempotent execution
- Minimal system modification
- Secure defaults
- CI-tested with Molecule

The role only enables EPEL when running on supported RedHat-family systems.

---

## Requirements

- Ansible >= 2.14
- Root privileges

---

## Role Variables

Defaults are defined in `defaults/main.yml`.

```yaml
epel_repo_url: "<auto-detected>"
epel_repo_gpg_key_url: "<auto-detected>"
epel_enabled: true
