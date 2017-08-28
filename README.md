This project supplies a usable environment in order to make tests around [OpenStack][1] using [CockroachDB][2] as a backend for its services.

This project is developed in the context of the [Discovery][3] initiative.

# Getting started

## Set up the environment
### Deploying your VM(s)
To run this project you have to install [vagrant][4]. Once installed and configured, deploy your VM(s) using `vagrant up x`. You can deploy choose either CockroachDB or PostgreSQL as backend but you can also deploy two VMs using one each to make some comparisons for instance.
* `vagrant up cockroachdb` to deploy a VM which will use CockroachDB as backend for OpenStack' services.
* `vagrant up psql` to deploy a VM which will use PostgreSQL as backend for OpenStack' services.
* `vagrant up` to deploy two VMs, one using CockroachDB and the other using PostgreSQL.

#### Deploying on Grid5000 platform.
You can easily deploy this project on Grid5000 platform using [vagrant-g5k plugin][5].
* `vagrant up [backend] --provider=g5k`

### Deploying OpenStack
Once your VM is deployed, you are able to deploy OpenStack using [Devstack][6]. For now, this project only deploy Keystone and Rally services.
* `vagrant provision [backend]`

## Jump onto your VM and start using Openstack cli

* Jump onto you WM using `vagrant ssh [backend]`.
* Start to use the Openstack cli by switching to **stack** user with `sudo su stack`.
* Once here you can use openstack cli to create a new project for instance `openstack project create keystone --or-show`
* You can also use Rally to run some scenarii over Keystone (e.g. `rally task start /opt/stack/rally/samples/tasks/scenarios/keystone/create-and-delete-user.yaml`) 

# Limitations

Until now, this project is only deploying Keystone service with a cockroachDB backend and we had to skip databases migrations due to some problems with sqlalchemy-migrate. To bypass migrations we deployed a posgreSQL-backended Keystone and dumped its database and apply this dump to our cockroachDB-backended Keystone.  

# Future work

* Deal with sqlalchemy-migrate migrations.
* Make some benchmark to show out differences with a standard mysql-backended Keystone.
* Expand this tool to other Openstack services.

# Links

* [OpenStack][1]
* [CockroachDB][2]
* [Discovery][3]
* [Vagrant][4]
* [vagrant-g5k plugin][5]
* [Devstack][6]


[1]: https://openstack.org
[2]: https://cockroachlabs.com/
[3]: https://beyondtheclouds.github.io/
[4]: https://vagrantup.com/
[5]: https://github.com/msimonin/vagrant-g5k
[6]: https://github.com/openstack-dev/devstack
