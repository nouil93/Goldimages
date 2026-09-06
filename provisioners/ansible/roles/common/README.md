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

## Debian Bash prompt

Debian uses `/etc/profile.d/90-goldimage-prompt.sh`, also loaded through an
Ansible-managed block in `/etc/bash.bashrc` for interactive non-login Bash.
The role removes its legacy `/etc/profile.d/ps1.sh` on Debian. Other distributions
retain the legacy prompt controlled by `common_manage_ps1`.

Defaults:

```yaml
common_shell_prompt_enabled: true
common_environment: template
common_shell_prompt_show_fqdn: false
```

Environments are `template` (blue), `dev` (green), `test` (cyan), `staging`
(yellow), and `prod` (bright red). The prompt shows `[ENV] user@host directory $`,
with a red root identity and `#` for root. Set `common_shell_prompt_show_fqdn`
to use Bash's full hostname escape. No machine-specific values are baked in.

The script ignores non-interactive shells and `TERM=dumb`, guards against
repeated sourcing, and appends a Bash function to existing `PROMPT_COMMAND`
hooks so user startup PS1 assignments do not override the system prompt.
It runs only Bash builtins and wraps colors in Bash nonprinting markers.
Disabling `common_shell_prompt_enabled` removes the script and managed loader;
existing shells retain their prompt until restarted. User dotfiles are untouched.

Run local rendering and Bash checks from the repository root:

```sh
python3 -m unittest discover -s test -p test_shell_prompt.py -v
```

The `molecule/debian13` scenario tests the common role's shell tasks,
including converge idempotence, deployed ownership/mode, shell startup, and
removal/restoration. It requires Molecule's Docker driver and a container runtime:

```sh
cd provisioners/ansible/roles/common
molecule test -s debian13
```

## Debian interactive Bash history

History is a separate feature from the colored prompt, intended for operator
convenience. The role installs `/etc/profile.d/91-goldimage-history.sh` as
`root:root`, mode `0644`, and adds a distinct `GOLDIMAGE HISTORY` managed block to
`/etc/bash.bashrc` for interactive non-login shells. No user startup files or
`/etc/skel` files are modified.

```yaml
common_shell_history_enabled: true
common_shell_history_size: 20000
common_shell_history_file_size: 50000
common_shell_history_timestamp_format: "%Y-%m-%dT%H:%M:%S%z "
common_shell_history_sync: true
```

Sizes must be positive YAML integers. The timestamp format displays local time
with its UTC offset; Bash stores timestamps alongside history entries. The policy
sets `HISTCONTROL=ignoredups` and enables `histappend` and `cmdhist`. It does not
set `HISTIGNORE` or change `HISTFILE`: each user retains their normal history file.
Non-interactive Bash returns before any history settings or hooks are changed.

A dedicated Bash function appends new commands with `history -a`, then imports
other sessions' commands with `history -n` before each prompt. These are Bash
builtins. Concurrent history is best-effort sharing, not transactional ordering.
The function reapplies settings because user startup files may assign different
limits or `HISTCONTROL` after `/etc/bash.bashrc`. A user startup file that
reduces `HISTFILESIZE` can truncate existing history before the first prompt;
this policy cannot restore entries already removed. With synchronization disabled,
the hook still applies settings but does not call either history operation.

Writable string and indexed-array `PROMPT_COMMAND` forms are preserved, and a
shell-local guard prevents duplicate registration. The history hook returns its
incoming exit status, including when history I/O fails. It cannot recover a
status already changed by an earlier hook (including the existing prompt hook).
This implementation targets Debian 13's Bash; it is not intended for other
shells, readonly or associative-array `PROMPT_COMMAND` values, or older Bash
versions without indexed-array prompt-hook support. Users can replace hooks or
disable history themselves; the configuration is not an enforcement boundary.

Setting `common_shell_history_enabled: false` removes the history profile and
only its managed loader block. Existing shells keep their functions and settings
until restarted. Disabling history configuration does not erase users' history.

**Bash history is not tamper-proof auditing.** Users can delete or alter their own
history. For security-grade auditing, use auditd, sudo I/O logging, or centralized
session recording. Operators should never enter passwords, tokens, or other
secrets directly on command lines.

Run both local shell suites from the repository root:

```sh
python3 -m unittest discover -s test -p 'test_shell_*.py' -v
```

The existing `molecule/debian13` scenario now converges both independent features
and checks idempotence, installed history metadata, Bash syntax, interactive
settings, non-interactive guards, hook deduplication, and disable/restore behavior.
