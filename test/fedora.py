import testinfra
import pytest

def test_os_release(host):
    assert host.file("/etc/os-release").contains("fedora")

def test_cowsay(host):
    assert host.package('cowsay').is_installed

def test_package_capacity(host):
    with host.sudo():
        cmd = host.run("dnf install -y nginx ")
        print(cmd.stdout)
        assert cmd.succeeded
        assert host.package('nginx').is_installed

def test_systemd_status(host):
    with host.sudo():
        cmd = host.run("systemctl status")
        print(cmd.stdout)
        assert cmd.succeeded
