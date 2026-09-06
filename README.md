# GoldImages

GoldImages builds reusable Linux virtual machine images with Packer, QEMU/KVM,
and Ansible. GNU Make provides the entry point for image builds, validation,
and documentation generation.

The Debian workflow provisions a cloud image and produces a Libvirt QCOW2 disk.
Rocky Linux and CentOS Stream configurations use automated Kickstart installation.
Build profiles define image settings; the generic Debian environment defaults to
`template`.

## Build configurations

The Makefile currently exposes the following image targets. Availability of a
target does not imply that every platform and profile has been validated.

| Distribution | Version label | Output | Profiles |
| --- | --- | --- | --- |
| Debian | 13.6 | Libvirt QCOW2 | standard, production |
| Rocky Linux | 9.6 | Vagrant box | standard, production, samba, custom |
| Rocky Linux | 9.6 | Libvirt QCOW2 | standard, production |
| Rocky Linux | 9.7 | Vagrant box | standard |
| CentOS Stream | 9 | Vagrant box | standard |

Additional historical configurations and Nutanix post-processing code remain in
the repository. VMware VMDK conversion is a proposed extension and is not yet
implemented.

## Prerequisites

For image builds:

- A Linux host with QEMU/KVM and access to hardware virtualization.
- GNU Make, Bash, Python 3, and Python virtual environment support.
- Packer and its QEMU and Ansible plugins. The Makefile bootstraps Packer 1.13.1
  when the local binary is absent and initializes plugins with `make init`.
- OVMF firmware at the paths configured in the QEMU sources.
- Ansible dependencies from `requirements.txt`.
- An SSH key pair for the Debian build account.
- Network access to the configured image sources and package repositories.

Some packaging workflows also require libguestfs utilities. ShellCheck is used
for shell validation, Podman for Kickstart validation, and Docker for PDF
documentation generation.

## Quick start

List targets and their descriptions:

```bash
make help
```

Build the Debian standard Libvirt image:

```bash
make build/debian-13.6-libvirt.standard.uefi.qcow2
```

The default SSH key paths are `~/.ssh/id_ed25519` and
`~/.ssh/id_ed25519.pub`. Override them when needed:

```bash
make build/debian-13.6-libvirt.standard.uefi.qcow2 \
  ssh_private_key_file="$HOME/.ssh/build_key" \
  ssh_public_key_file="$HOME/.ssh/build_key.pub"
```

The resulting disk is written to:

```text
build/debian-13.6-standard-libvirt-uefi/debian-13.6-standard-libvirt-uefi.qcow2
```

Packer records the Debian build manifest in
`artifacts/manifest-debian-libvirt.json`. Actual artifact paths are determined by
the Packer image name; Make build targets are command aliases. Running a build
target again invokes Packer even if a previous artifact exists.

Other build examples:

```bash
make build/rocky-9.6-vagrant.standard.uefi.box
make build/rocky-9.6-libvirt.standard.uefi.qcow2
```

Preview a build command without running it:

```bash
make -n build/debian-13.6-libvirt.standard.uefi.qcow2
```

## Repository layout

| Path | Purpose |
| --- | --- |
| `Makefile` | Build, validation, and documentation targets |
| `mklib/` | Shared Make helpers and Packer bootstrap |
| `build.pkr.hcl` | Packer provisioning and post-processing pipelines |
| `source.debian-cloud.pkr.hcl` | Debian cloud-image QEMU source |
| `source.qemu.pkr.hcl` | Kickstart-based QEMU source and plugin declarations |
| `variables.pkr.hcl` | Shared Packer variable definitions |
| `data/` | Distribution and profile-specific build settings |
| `http/` | Installer configuration served during builds |
| `templates/cloud-init/` | Debian build-time cloud-init templates |
| `provisioners/ansible/` | Playbooks, roles, and distribution-specific tasks |
| `scripts/` | Installation and artifact post-processing scripts |
| `test/` | Local tests and historical integration tests |
| `doc/` | PDF template and supporting assets |
| `build/` | Generated image artifacts |
| `artifacts/` | Build manifests |

## Image configuration

Kickstart-based builds use predefined installation and partition profiles. The
Debian workflow starts from the cloud image selected in its variable file and
sets the virtual disk size through Packer. These are different installation paths;
profile names alone do not guarantee identical partition layouts.

The `production` build profile does not automatically set the shell environment
to `prod`. Generic images retain `common_environment: template` unless explicitly
configured otherwise.

The Ansible common role manages packages, SSH settings, MOTD, shell customization,
and selected sysctl values. Debian prompt and history policies use separate task
files, templates, and managed blocks in `/etc/bash.bashrc`.

```yaml
common_shell_prompt_enabled: true
common_environment: template
common_shell_prompt_show_fqdn: false

common_shell_history_enabled: true
common_shell_history_size: 20000
common_shell_history_file_size: 50000
common_shell_history_timestamp_format: "%Y-%m-%dT%H:%M:%S%z "
common_shell_history_sync: true
```

See the [common role documentation](provisioners/ansible/roles/common/README.md)
for configuration details, supported environments, and shell behavior.

Bash history supports operator usability; it is not tamper-proof auditing. Users
can alter or delete their history. Use auditd, sudo I/O logging, or centralized
session recording for security auditing, and avoid entering secrets directly on
command lines.

## Validation

Check Packer formatting and template syntax using the local binary:

```bash
./packer fmt -check .
./packer validate -syntax-only .
```

Run shell linting and the local prompt/history tests:

```bash
make tests/scripts
python3 -m unittest discover -s test -p 'test_shell_*.py' -v
```

The Python tests require Jinja2 and PyYAML in the selected Python environment.
Syntax checks and local tests do not establish that a guest boots or operates
correctly on its target hypervisor.

Validate the Rocky 9.7 standard Vagrant Kickstart configuration:

```bash
make validate/rocky-9.7-standard-vagrant-uefi.ks
```

The common role also contains Molecule scenarios. The Debian scenario tests shell
configuration and requires Molecule, its Docker driver, and a container runtime.
See the role documentation for execution instructions.

The existing GitLab CI configuration contains legacy commands and placeholder
jobs. It requires updating before it can validate the current build workflow.

## Documentation

Generate a PDF from this README:

```bash
make build/doc
```

The target runs Pandoc and XeLaTeX in Docker, using the Eisvogel template and
supporting assets in `doc/`. The generated PDF is written to `doc/`.

## Contributing

Keep changes scoped to the relevant build profile, provisioner, or packaging
workflow. Include validation results and identify any behavior that was not tested.
Preserve working build targets when introducing additional artifact formats.

## License

Project license terms are provided in [LICENCE](LICENCE). Third-party tools and
bundled components retain their respective licenses.
