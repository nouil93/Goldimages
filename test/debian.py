import testinfra
import pytest

def test_os_release(host):
    assert host.file("/etc/os-release").contains("fedora")

def test_cowsay(host):
    assert host.package('cowsay').is_installed