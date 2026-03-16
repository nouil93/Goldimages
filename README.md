# Goldimages

**Goldimages** is an opinionated, production-grade image factory for building **secure, reproducible Linux “gold images”** using **Packer + QEMU/KVM**.

The project standardizes OS installation, partition layouts, hardening, and post-install configuration across **Rocky Linux**, **Red Hat Enterprise Linux**, and **CentOS Stream**, targeting both **on-prem virtualization** and hybrid environments.

> This repository reflects real-world enterprise practices (RHEL 9.x, Nutanix AHV, immutable images, CI/CD, documentation-driven infrastructure).

---

## ✨ Features

- 🔁 Reproducible builds using **Packer (HCL)**
- 🧱 Multiple **partition profiles**:
  - `standard`
  - `production`
  - `samba`
  - `custom`
- 🔐 UEFI + GPT layouts
- 🧰 Multi-target outputs:
  - Vagrant (`.box`)
  - Libvirt / Nutanix (`.qcow2`)
- 📜 Fully automated OS installation (Kickstart)
- 📚 PDF documentation generation (Pandoc + LaTeX)
- 🧪 CI-ready (validation, linting, smoke tests)
- ♻️ Designed for long-term maintenance and audits

---

## 🏗️ Project Structure

```
goldimages/
├── Makefile
├── mklib/
│   ├── common.mk
│   ├── packer.mk
│   └── Goldimages.art
├── data/
│   └── rocky/9.6/
│       ├── standard.pkrvars.hcl
│       ├── production.vagrant.pkrvars.hcl
│       ├── samba.vagrant.pkrvars.hcl
│       └── custom.vagrant.pkrvars.hcl
├── packer/
│   ├── builders/
│   ├── provisioners/
│   └── sources/
├── doc/
│   └── goldimage.md
└── build/
```

---

## 🚀 Quick Start

### Prerequisites

- GNU Make
- Packer ≥ **1.13**
- QEMU / KVM
- libvirt
- Docker (for documentation builds)

---

### Build a Rocky Linux 9.6 Vagrant image

```bash
make build/rocky-9.6_vagrant.standard.uefi.box
```

### Build a Libvirt qcow2 image

```bash
make build/rocky-9.6-standard-libvirt.uefi.qcow2
```

---

## 📦 Supported Platforms

| OS | Version | Targets |
|----|--------|---------|
| Rocky Linux | 9.6 | Vagrant, Libvirt, Nutanix |
| RHEL | 9.6 | Vagrant, Libvirt, Nutanix |
| CentOS Stream | 9 | Vagrant, Libvirt |

---

## 🧠 Partition Strategy

Goldimages intentionally uses **static, predefined partition layouts** built at image-creation time.

### Why?

- Predictable disk layouts
- Easier backups and restores
- Stronger security boundaries
- Compliance-friendly (audits, SOPs)
- No risky runtime resizing

### Recommended model

A **hybrid approach** is encouraged:

- Disk layout defined during image build
- Logical volumes sized for growth
- `cloud-init` used only for:
  - SSH keys
  - Users
  - Hostname
  - Networking
  - Instance-specific configuration

This mirrors how **enterprise on-prem and regulated environments** operate.

---

## 📚 Documentation

Documentation is built using:

- **Pandoc**
- **XeLaTeX**
- **Eisvogel template**

Build the PDF documentation:

```bash
make build/doc
```

---

## 🧪 CI / Quality

The project is designed to integrate easily with CI systems:

### Suggested checks

- `packer fmt -check`
- `packer validate`
- ShellCheck (Kickstart / shell scripts)
- Makefile linting
- Documentation build

### Recommended CI platforms

- **GitHub Actions** (preferred)
- GitLab CI
- Travis CI (supported but aging)

---

## 🔧 Makefile Philosophy

The Makefile:
- Acts as the **single entry point**
- Encodes build intent explicitly
- Is designed to be refactored into:
  - Pattern rules
  - Centralized packer flags
  - Automatic packer download and checksum validation

This makes the project portable across laptops, CI runners, and air-gapped environments.

---

## 🎯 Use Cases

- Enterprise gold image pipelines
- Nutanix AHV environments
- Vagrant / libvirt labs
- Secure baseline OS images
- Infrastructure standardization
- Training and demonstration projects

---

## 📄 License

```
(C) 2000–2025
Frédéric Delacour
```

You may choose to release this project under **MIT** or **Apache-2.0** for broader adoption.

---

## 🤝 Contributing

Contributions are welcome:
- New OS versions
- Additional partition profiles
- CI improvements
- Documentation enhancements

Please open an issue or submit a pull request.

---

## ⭐ Why Goldimages?

Because infrastructure should be:
- Predictable
- Auditable
- Reproducible
- Documented

**Goldimages treats operating systems as artifacts, not pets.**
