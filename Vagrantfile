# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Vagrantfile Deploying 2 nodes in order to compare pgsql and cockroachdb backends
#
DEBUG = false
G5K_USER = "acarat"

Vagrant.configure(2) do |config|

  # Configuration for VirtualBox
  config.vm.provider :virtualbox do |vb, override|
    vb.cpus = 4
    vb.memory = 4096
    override.vm.synced_folder "./", "/vagrant_data",
                              owner: "vagrant",
                              group: "vagrant"
  end #vb

  # Configuration for G5k
  config.vm.provider "g5k" do |g5k, override|
    # This is mandatory for the shared folders to work correctly
    override.nfs.functional = false
    # vagrant-g5k only supports rsync shared folders
    override.vm.synced_folder ".", "/vagrant", type: "rsync", disabled: false

    #override.ssh.username = 'root'
    override.ssh.insert_key = false

    # project id must be unique accross all
    # your projects using vagrant-g5k to avoid conflict
    # on vm disks
    g5k.project_id = "cockroach-os"
    g5k.site = "rennes"
    g5k.username = G5K_USER
    g5k.gateway = "access.grid5000.fr"
    g5k.walltime = "07:30:00"
    #g5k.private_key = "your private key"

    # Image backed on the frontend filesystem
    g5k.image = {
      :path    => "/home/acarat/debian-8.7-amd64-bento.qcow2",
      :backing => "snapshot"
    }

    ## Nat network : VMs will only have access to the external world
    ## Forwarding ports will allow you to access services hosted inside the
    ## VM.
    g5k.net = {
      :type => "nat",
      :ports => ["2222-:22", "8080-:8080", "8888-:80"]
    }

    ## OAR selection of resource
    g5k.oar = "virtual != 'none'"
    #g5k.oar = "virtual != 'None' and network_address in ('paranoia-2.rennes.grid5000.fr')"
    #g5k.oar = "network_address in ('igrida12-12.irisa.fr')"

    ## VM size customization default values are
    g5k.resources = {
      :cpu => 6,
      :mem => 8192
    }
  end #g5k

  # VM for CockroachDB backend
  config.vm.define "cockroachdb" do |roach|
    roach.vm.box = "debian/contrib-jessie64"
    roach.vm.provision :ansible_local do |ansible|
      ansible.install_mode = "pip"
      ansible.version = "2.3.1.0"
      ansible.playbook = "provision.yml"
      # ansible.verbose = "-vvvv"
      ansible.extra_vars = {
        :backend => "cockroachdb",
        :debug => DEBUG
      }
    end
  end

  # VM for PostreSQL backend
  config.vm.define "psql" do |psql|
    psql.vm.box = "debian/contrib-jessie64"
    psql.vm.provision :ansible_local do |ansible|
      ansible.install_mode = "pip"
      ansible.version = "2.3.1.0"
      ansible.playbook = "provision.yml"
      # ansible.verbose = "-vvvv"
      ansible.extra_vars = {
        :backend => "psql",
        :debug => DEBUG
      }
    end
  end
end
