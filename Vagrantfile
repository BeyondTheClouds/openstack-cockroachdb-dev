# -*- mode: ruby -*-
# vi: set ft=ruby :

def ansible_provision(vm_object)
  vm_object.vm.provision :ansible_local do |ansible|
    ansible.install_mode = "pip"
    ansible.version = "2.3.1.0"
    ansible.playbook = "provision.yml"
    # ansible.verbose = "-vvvv"
    ansible.extra_vars = {
      :backend => vm_object.vm.hostname
    }
  end
end

Vagrant.configure("2") do |config|
  config.vm.box = "debian/contrib-jessie64"

  config.vm.synced_folder "./", "/vagrant_data",
                          owner: "vagrant",
                          group: "vagrant"

  config.vm.provider :virtualbox do |vb|
    vb.cpus = 4
    vb.memory = 4096
  end

  config.vm.define :psql do |psql|
    psql.vm.hostname = "psql"
    ansible_provision(psql)
  end

  config.vm.define :cockroachdb do |croach|
    croach.vm.hostname = "cockroachdb"
    ansible_provision(croach)
  end

  # config.vm.define :keystone do |keystone|
  #   keystone.vm.hostname = "keystone"
  #   keystone.vm.provision :ansible_local do |ansible|
  #     ansible.install_mode = "pip"
  #     ansible.version = "2.3.1.0"
  #     ansible.playbook = "only-keystone.yml"
  #     # ansible.verbose = "-vvvv"
  #   end
  # end
end
