---
title: "GoldImage"
author: "Frédéric Delacour"
subtitle: "Chpvp Virt Images"
titlepage: true
mainfont: "Libertinus Serif"
sansfont: "Libertinus Sans"
monofont: "Libertinus Mono"
header-left: "\\hspace{1cm}"
header-center: "\\leftmark"
header-right: "Page \\thepage"
footer-left: "\\thetitle"
footer-right: "\\theauthor"
...


\vspace{1cm}

\arrayrulecolor{maincolor!20} 
\begin{table}[htbp]
\centering
\caption*{Document Information}
\begin{tabularx}{\textwidth}{|l|X|}
\hline
Project Name     & Goldimages \\
\hline
Document Path    & \texttt{/Hope\_IT/IT-Docs/gitlabci/goldimages.md} \\
\hline
Revision Date    & \today \\
\hline
Version          & 1.0 \\
\hline
Maintainer       & Frédéric Delacour \\
\hline
Contact Email    & \texttt{frederic.delacour@gmail.com} \\
\hline
\end{tabularx}
\end{table}

\clearpage

# Goldimages Chpvp Virt Images

## Overview

**Goldimages** standardizes and automates the building of system images for various RHEL and RHEL-compatible distributions using 
[Packer](https://www.packer.io/). The project provides versioned templates for:

* **Rocky Linux 9.6**
* **Red Hat Enterprise Linux 9.6**
* **CentOS Stream 9**

Each image supports UEFI + several Profile partitioning and is tailored for different virtualization targets (Libvirt, Nutanix, Vagrant).

## Releases

\arrayrulecolor{maincolor!20} 


\begin{table}[htbp]
\centering
\caption*{\textcolor{maincolor}{\textbf{Release: \texttt{rocky9.6-vagrant-standard-uefi.box}}}}

\begin{tabularx}{\textwidth}{|l|X|}
\hline
\rowcolor{maincolor!20}
\textbf{Field} & \textbf{Details} \\
\hline
Target & Vagrant \\
\hline
Partition Scheme & Standard 100\,GB \\
\hline
Profile & Standard \\
\hline
Build Command & \texttt{make build/rocky9.6\_vagrant.standard.uefi.box} \\
\hline
\end{tabularx}
\end{table}

### Release: `rocky9.6-vagrant-standard-uefi.box`

* **Target:** Vagrant
* **Partition Scheme:** Standard 100 GB
* **Profile:** Standard
* **Build Command:**

  ```sh
  make build/rocky9.6_vagrant.standard.uefi.box
  ```

### Release: `rocky9.6-vagrant-production-uefi.box`

* **Target:** Vagrant
* **Partition Scheme:** Production 50 GB
* **Profile:** Production
* **Build Command:**

  ```sh
  make build/rocky9.6-vagrant-production-uefi.box
  ```

### Release: `rocky9.6_libvirt.standard.uefi.qcow2`

* **Target:** Libvirt
* **Partition Scheme:** Standard 100 GB

### Release: `centos9_vagrant.standard.uefi.box`

* **Target:** Vagrant
* **Partition Scheme:** Standard 40 GB

### Release: `redhat9.6_nutanix.standard.uefi.qcow2`

* **Target:** Nutanix
* **Partition Scheme:** Standard 100 GB

*Additional builds exist for each distribution and target.*

## Partition Profiles

### Standard Profile (100 GB)

* `/boot/efi`: 600 MB (FAT32)
* `/boot`: 1 GB (XFS)
* `/`: 80+ GB (XFS)
* `swap`: 2 GB

### Production Profile (50 GB)

Partitioned with LVM (XFS) and designed for server use:

\begin{table}[htbp]
\centering
\caption{Production Profile Partition Layout (50 GB)}
\begin{tabular}{|l|l|p{8cm}|}
\hline
\textbf{Mount Point} & \textbf{Size} & \textbf{Purpose} \\
\hline
/boot/efi   & 600MB & EFI system partition \\
/boot       & 1GB   & Bootloader \& kernel \\
swap        & 2GB   & Swap space \\
/           & 8GB   & Root filesystem \\
/var        & 8GB   & System logs, spool, yum cache \\
/opt        & 4GB   & Optional software \\
/tmp        & 2GB   & Temporary files \\
/srv        & 2GB   & Service-specific data \\
/var/log    & 4GB   & Logs \\
/var/tmp    & 2GB   & Temporary data preserved across reboots \\
/home       & 2GB   & User home directories \\
/usr        & rest  & System binaries and libraries \\
\hline
\end{tabular}
\end{table}


## Users & Permissions

Each image is provisioned with:

* **User:** `vagrant`

  * **Passwordless sudo:** Yes
  * **SSH Key:** Vagrant default

* **User:** `admin`

  * **Customizable via provisioning scripts**

Root access is enabled by default for automation and can be restricted post-deploy.

## Directory Structure

```
Goldimages/
├── Makefile
├── mklib/
│   ├── common.mk
│   ├── packer.mk
│   └── Goldimages.art
├── data/
│   └── <distro>/<version>/<profile>.pkrvars.hcl
├── build/
│   └── <outputs>
```
## Build Instructions

```sh
make build/centos9_vagrant.standard.uefi.box
```
## Future Enhancements

* Support secure boot with signed kernels
* CI/CD release pipeline via GitLab CI

For more details, contact **[frederic.delacour@gmail.com](mailto:frederic.delacour@gmail.com)** or check the included `mklib/` libraries and variable files in `data/`.

---
