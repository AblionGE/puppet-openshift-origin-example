# All-In-One installation of Openshift Origin

This repository is here to help people to set up an Openshift Origin with all Openshift components on the same host in a virtual machine. The idea is to play with this PaaS solution to have an idea of what is possible to do with it. 

# Requirements

To be able to play with Openshift, you need to have installed :

* Vagrant (https://www.vagrantup.com)
* r10k (https://github.com/puppetlabs/r10k)
* rake (https://github.com/ruby/rake)

# Installation

First, you need to update modules to your machine running

    rake dependencies:deploy

If you see some errors, simply re-run this command.

Then, you have to set up your machine. the Vagrantfile is already in the repo and Vagrantfile.one is simply a copy for when you destroy by inadvertence the Vagrantfile

    rake dev:up

This command will download the VM and update it.

Then, you have to run puppet using

    rake dev:apply_site

The file site.pp is the entry point of puppet (as we are not in a master-agent infrastructure) and everything in this file will be executed by puppet on the guest machine.

During the installation, SELinux will be installed and set to 'permissive' mode (it requires a reboot of the machine). As the machine will not mount the sync folder after the reboot you will have to run the following command the reboot manually and mount the sync folder :

    rake dev:reload

When the machine is up, you need again to run

    rake dev:apply_site

It will continue the installation. At the end, you have an operational Openshift Origin Installation.

# How to use it

To use and test openshift, you need to configure it manually.
To do so, just connect on the guest machine with ssh

    vagrant ssh

Then, according to the Openshift Origin documentation, you need to create district, add the node (your machine) to this district and activate cartridges.
To do that, run the following commands as root

    sudo oo-admin-ctl-district -c create -n small_district -p small
    sudo oo-admin-ctl-district -c add-node -n small_district -a
    sudo oo-admin-ctl-cartridge -c import-node --activate

Now you should be able to access Openshift through your favorite web browser on the ip https://192.168.56.10
