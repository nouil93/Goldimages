import testinfra
import pytest
import pyone

ONE_URL="http://one.openmyweb.local:2633/RPC2"
IMG_NAME='testinfraImg'

def test_passwd_file(host):
    passwd = host.file("/etc/passwd")
    assert passwd.contains("root")
    assert passwd.user == "root"
    assert passwd.group == "root"

def test_os_release(host):
    assert host.file("/etc/redhat-release").contains("CentOS")

def test_opennebula_running_and_enabled(host):
    opennebula = host.service("opennebula")
    assert opennebula.is_running
    assert opennebula.is_enabled

def test_opennebula_one_auth(host):
    with host.sudo():
        one_auth = host.file("/var/lib/one/.one/one_auth")
        print(one_auth)
        assert one_auth.contains("oneadmin")
        assert one_auth.user == "oneadmin"
        assert one_auth.group == "oneadmin"

def test_opennebula_sunstone_auth(host):
    with host.sudo():
        sunstone_auth = host.file("/var/lib/one/.one/sunstone_auth")
        assert sunstone_auth.contains("serveradmin")

def test_opennebula_ec2_auth(host):
    with host.sudo():
        assert host.file("/var/lib/one/.one/ec2_auth").exists

def test_opennebula_occi_auth(host):
    with host.sudo():
        assert host.file("/var/lib/one/.one/occi_auth").exists

def test_opennebula_one_auth(host):
    with host.sudo():
        assert host.file("/var/lib/one/.one/one_auth").exists

def test_opennebula_oneflow_auth(host):
    with host.sudo():
        assert host.file("/var/lib/one/.one/oneflow_auth").exists

def test_opennebula_ec2_auth(host):
    with host.sudo():
        assert host.file("/var/lib/one/.one/ec2_auth").exists

def test_opennebula_onegate_auth(host):
    with host.sudo():
        assert host.file("/var/lib/one/.one/onegate_auth").exists

def test_opennebula_one_key(host):
    with host.sudo():
        assert host.file("/var/lib/one/.one/one_key").exists

def test_opennebula_sunstone_auth(host):
    with host.sudo():
        assert host.file("/var/lib/one/.one/sunstone_auth").exists

def test_opennebula_new_image(host):
    with host.sudo():
        one_auth = host.file("/var/lib/one/.one/one_auth")

        one = pyone.OneServer(ONE_URL, one_auth.content_string.strip())
        image = {
            'name': IMG_NAME,
            'path': 'http://src.openmyweb.local/CentOS-7-x86_64-GenericCloud.qcow2',
            'lock': 'None'
        }
        one.image.allocate(image, 1, True)
        lstimg = one.imagepool.info(-2,-1,-1)
        for img in lstimg.IMAGE:
            if img.NAME == IMG_NAME:
                assert True
                one.image.delete(img.ID)
            print(img.NAME)
            print(img.ID)

        print(one_auth.content_string.strip())
        assert one_auth.contains("oneadmin")
        assert one_auth.user == "oneadmin"
        assert one_auth.group == "oneadmin"
    return "project deps: mylib-1.1"

