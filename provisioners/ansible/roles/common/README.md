# Ansible Role : common

## Description

Configuration d'un motd et du PS1 du bashrc.
Installation des dependances de base


## Compatibilité

- Centos7
- Fedora31
- Ubuntu18.04
- Ubuntu20.04

## Variables

```yaml
# Définition des virtual hosts
common_packages:
  - cowsay
  - vim
  - net-tools
```

## Changelog

20200108 : version initiale
20200303 : ajout Compatibilite Fedora31
20200504 : ajout Compatibilite Fedora32
  suppression dependance epel.
