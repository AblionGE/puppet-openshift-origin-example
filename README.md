# All-In-One installation of Openshift Origin

This repository is here to help people to set up an Openshift Origin with all Openshift components on the same host in a virtual machine. The idea is to play with this PaaS solution to have an idea of what is possible to do with it. 

# Requirements

To be able to play with Openshift, you need to have installed :

* Vagrant (https://www.vagrantup.com)
* r10k (https://github.com/puppetlabs/r10k)
* rake (https://github.com/ruby/rake)

# Installation

First, you need to clone this repo

    git clone https://github.com/AblionGE/puppet-openshift-origin-example.git

Then, you need to update modules to your machine running

    rake dependencies:deploy

If you see some errors, simply re-run this command.

Then, you have to set up your machine. The Vagrantfile is already in the repo and Vagrantfile.one is simply a copy for when you destroy by inadvertence the Vagrantfile

    rake dev:up

This command will download the VM and update it using the Vagrantfile.

Then, you have to run puppet using

    rake dev:apply_site

The file site.pp is the entry point of puppet (as we are not in a master-agent infrastructure) and everything in this file will be executed by puppet on the guest machine. After the installation of SELinux, the guest machine will reboot because of SELinux.

When the machine is up, you need to run again

    rake dev:apply_site

It will continue the installation. At the end, you have an operational Openshift Origin Installation.

If you have some problems to run puppet after the reboot ('cannot find site.pp' for example), it is because the shared folders were not mount automatically. If so, you just need to reload the guest machine via vagrant with the command

    rake dev:reload

# How to use it

To use and test openshift, you need to configure it manually.
To do so, just connect yourself on the guest machine with ssh

    vagrant ssh

Then, according to the Openshift Origin documentation, you need to create district, add the node (your guest machine) to this district and activate cartridges.
To do that, run the following commands on the guest machine :

    sudo oo-admin-ctl-district -c create -n small_district -p small
    sudo oo-admin-ctl-district -c add-node -n small_district -a
    sudo oo-admin-ctl-cartridge -c import-node --activate

Now you should be able to access Openshift through your favorite web browser on https://192.168.56.10 or https://localhost:2443 (or the ip you have set in the Vagrantfile)

When you create an application, 192.168.56.10 is directly linked to this application. You need to go on https://localhost:2443 to access the Openshift console and to manage your apps.

The login account is hardcoded in the openshift class and is
- username : demo
- password : changeme

# Tricks
On your guest host, you can execute

    rake
    
to see all commands available in the Rakefile
