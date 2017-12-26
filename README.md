This project supplies a usable environment in order to make tests
around [OpenStack/pike][1] using [CockroachDB][2] as a backend for its
services.

List of current supported services:
* Keystone

This project is developed in the context of the Inria [Discovery][3]
initiative. You may find an explanation of modifications performed in
this repository on the [Discovery Blog][7].

# Getting started

## Set up the environment
### Deploying your VM(s)
To run this project you have to install [vagrant][4]. Once installed,
deploy your VM(s) and run [Devstack][6] using `vagrant up
--provision`. Devstack then deploys OpenStack with CockroachDB for
supported services and PostgreSQL otherwise.

Once the shell displays the following message:
```
TASK [Start of Devstack deployment] ********************************************
ok: [cockroachdb] => {
    "msg": [
        "Follow deployment with:",
        "vagrant ssh cockroachdb -- tail -f /tmp/stack-logs"
    ]
}
```

Run the command `vagrant ssh cockroachdb -- tail -f /tmp/stack-logs`
in another shell to follow the deployment of OpenStack.


<!---
You can also allow keystone debugging mode (_keystone-wsgi-admin_) by setting setting DEBUG to true in [Vagrantfile](Vagrantfile#L6).
--->

#### Deploying on Grid5000 platform.
You can easily deploy this project on Grid5000 platform using [vagrant-g5k plugin][5].
* `vagrant up --provider=g5k`

## Jump onto your VM and start using OpenStack cli
* Jump onto you WM using `vagrant ssh`.
* Start to use the OpenStack cli by switching to **stack** user with
  `sudo su stack`.
* Once here you can use OpenStack cli to create a new project for
  instance `openstack project create keystone --or-show`
* You can also use Rally to run some scenarii over Keystone (e.g.
  `rally task start
  /opt/stack/rally/samples/tasks/scenarios/keystone/create-and-delete-user.yaml`)

# Limitations

Until now, this project is only deploying Keystone service with
CockroachDB as backend.

# Future work

* Make some benchmark to show out differences with a standard
  mysql-backended Keystone.
* Expand this tool to other OpenStack services.

# Links

* [OpenStack][1]
* [CockroachDB][2]
* [Discovery][3]
* [Discovery Blog][7]
* [Vagrant][4]
* [vagrant-g5k plugin][5]
* [Devstack][6]


[1]: https://openstack.org
[2]: https://cockroachlabs.com/
[3]: https://beyondtheclouds.github.io/
[4]: https://vagrantup.com/
[5]: https://github.com/msimonin/vagrant-g5k
[6]: https://docs.openstack.org/devstack/latest/
[7]: https://beyondtheclouds.github.io/blog/openstack/cockroachdb/2017/12/22/a-poc-of-openstack-keystone-over-cockroachdb.html
