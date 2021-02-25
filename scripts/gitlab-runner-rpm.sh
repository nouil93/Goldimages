#!/bin/bash
echo "Phase: gitlab-runner-rpm.sh"

# export VER="2.22.0"

# sudo yum groupinstall "Development Tools"
# sudo yum -y install wget perl-CPAN gettext-devel perl-devel gcc  openssl-devel  zlib-devel

# wget https://github.com/git/git/archive/v${VER}.tar.gz
# tar -xvf v${VER}.tar.gz
# rm -f v${VER}.tar.gz
# cd git-*
# sudo make install
sudo yum -y install  https://centos7.iuscommunity.org/ius-release.rpm
sudo yum -y install  git2u-all
curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/rpm/gitlab-runner_amd64.rpm
sudo rpm -i gitlab-runner_amd64.rpm
# curl -q -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh 2>/dev/null | sudo bash
# sudo dnf install -y gitlab-runner
# sudo usermod -aG docker gitlab-runner
# sudo systemctl restart gitlab-runner

echo "gitlab-runner       ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/gitlab-runner
sudo yum install -y cowsay
sudo yum install -y python3-venv
sudo yum install -y cpu-checker
sudo yum install -y qemu qemu-kvm libvirt-bin  bridge-utils  virt-manager
sudo yum install -y python36
sudo usermod -aG kvm gitlab-runner


PROVIDER=$(virt-what)
if [ "$PROVIDER" != "" ]; then
GITLABCI_TAGS+=",provider_${PROVIDER}"
fi

# for debug
# echo GITLABCI_URL=$GITLABCI_URL
# echo GITLABCI_TOKEN=$GITLABCI_TOKEN
# echo GITLABCI_EXECUTOR=$GITLABCI_EXECUTOR
# echo GITLABCI_TAGS=$GITLABCI_TAGS

sudo gitlab-runner register \
	--non-interactive \
	--name "$GITLABCI_NAME" \
	--url "$GITLABCI_URL" \
	--registration-token "$GITLABCI_TOKEN" \
	--executor "$GITLABCI_EXECUTOR" \
	--tag-list "$GITLABCI_TAGS" \
	--docker-image ubuntu

# for more options see gitlab-runner register --help
