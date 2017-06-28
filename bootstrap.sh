#!/usr/bin/env bash
set -x

# 1. Download Devstack
#apt update -y; apt install -y git sudo

useradd -s /bin/bash -d /opt/stack -m stack

echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack


sudo -H -u stack git clone https://git.openstack.org/openstack-dev/devstack /devstack
sudo -H -u stack sed -i 's/HOST_IP=${HOST_IP:-}/ HOST_IP=10.0.2.15/' /devstack/stackrc

#Install cockroachdb
#curl -O https://binaries.cockroachdb.com/cockroach-v1.0.2.linux-amd64.tgz
tar xfz cockroach-v1.0.2.linux-amd64.tgz
cp -i cockroach-v1.0.2.linux-amd64/cockroach /usr/local/bin

#Start cockroach
cockroach start --host=localhost --insecure --background


# 4. Make the configuration file required by DevStack
sudo -H -u stack cat > /devstack/local.conf <<- EOF
[[local|localrc]]
ADMIN_PASSWORD=admin
DATABASE_PASSWORD=admin
RABBIT_PASSWORD=admin
SERVICE_PASSWORD=admin

disable_service tempest swift nova neutron glance

# -----
[[post-config|\$KEYSTONE_CONF]]

[database]
connection = cockroachdb://root@localhost:26257

EOF

# 5. Run Devstack as stack user
# Run DevStack
sudo -H -u stack /devstack/unstack.sh
sudo -H -u stack /devstack/stack.sh
