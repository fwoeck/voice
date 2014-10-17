Wimdu Voice is an IP telephony distribution that aims to provide many workflow elements
needed by call center agents and supervisors in one integrated platform.

It offers a fully automated but customizable installation and contains all necessary layers
like the SIP server and a modern, easy to use web interface.


## Overview

tbd.


## Screenshots

Incoming call pane: the default view for an agent when a customer calls in.
You can see the customer's history and the latest CRM tickets.

![voice-1](/images/voice-1.png)

Customer history search: agents can look for specific calls, pending tickets or mailbox messages here.
They can update entry states or use them to do outbound calls.

![voice-2](/images/voice-2.png)

Statistical overview: this gives a broad summary of the current call situation and shows details for teams.
Calls and timings are aggregated for the last 24h.

![voice-3](/images/voice-3.png)

Agent preference settings: this is where agents go to adjust their profile and admins add new agents.
The supported languages and skills are freely customizable.

![voice-4](/images/voice-4.png)


## Project Status

We don't consider the Voice platform production ready at this point. It's being tested internally and will
very likely be modified as we see fit. As soon as things stabilize, we'll hit 1.0 and will switch to semantic versioning.


## Getting Started

As the installation is fully driven by [Chef](https://www.getchef.com/chef/), trying out the platform is almost effortless.
Its as simple as cloning this repo, customizing one file and typing "vagrant up".


### Installation to a Virtualbox VM via Vagrant

#### Prerequisites

It's recommended to have at least a recent quad-core machine with 8Gbyte of free ram for things to run smoothly. Installations are
tested with OsX 10.9.5 and Ubuntu 14.04.

* Grab the latest copy of [Virtualbox](https://www.virtualbox.org/wiki/Downloads) (currently 4.3.18), including the Extension Pack.
* Also, you'll need to install [Vagrant](https://www.vagrantup.com/downloads.html) (currently 1.6.5).

* Now get the [vagrant-omnibus](https://github.com/opscode/vagrant-omnibus) plugin that helps us keeping the Chef client up to date:

```
> vagrant plugin install vagrant-omnibus
```

#### Getting a running stack

This repo contains all necessary information that will drive the setup. Clone it and create a local copy of the [Vagrantfile.example](/Vagrantfile.example).
Then change at least the mandatory options **before** you start the VM. You'll find a summary of the main configuration values in the next paragraph.

```
> git clone git://github.com/fwoeck/voice.git
> cd voice
> cp Vagrantfile.example Vagrantfile
> vi Vagrantfile
> vagrant up
```

Depending on the speed of your machine and internet connection, the basic provisioning typically takes between 30 and 45 minutes.


#### The Vagrantfile configuration

These are the mandatory things to be set **before** the first provisioning happens. We deliberately chose a public IP (33.33.33.100) for
the local environment to reduce the likelihood of network conflicts. This should be just fine for your installation.

The host and domain names don't really matter, as you'll add them to your /etc/hosts file.
Of course, you may choose a DNS controlled name and use your own SSL certificates later on.

There are two distinct [Chef-roles](/roles) the VM can be configured for. The "desktop"-role is intended for local development of the Voice stack and
the "server"-role is meant for production use. The two environments are almost identical, except for these things:

* "desktop" uses MRI ruby 2.1 for shorter response cycles during development
* "server" uses jRuby for better instrumentation and memory control
* "desktop" uses the "vagrant"-user as primary actor whereas "server" uses "wim"

We recommend to go with the "desktop"-default unless you want to conduct some smoke tests with the production environment.
Please refer to the [Vagrantfile.example](/Vagrantfile.example) for more available options including Zendesk support and VoIP
provider settings.

```
host            = 'voice01'                 # Host name of the new virtual node
domain          = 'wimdu.com'               # Domain name of the VM

ipaddress       = '33.33.33.100'            # Ip address of external VM interface
gateway         = '33.33.33.1'              # Ip address of VM gateway
interface       = 'eth0'                    # External interface of the VM

localnet        = '192.168.178.0'           # Environmental local net, used for routing
netmask         = '255.255.255.0'           # Netmask of environmental local net

chef_role       = 'desktop'                 # Set to 'server' for production-environments
gitbase         = 'git://github.com/fwoeck' # Set to 'git@github.com:<gh-user>' for private forks

ami_pass        = '<password>'              # Used to communicate with the Asterisk AMI
mysql_wim_pass  = '<password>'              # Used for regular DB connections
mysql_root_pass = '<password>'              # Used for root access to MySQL
rabbitmq_pass   = '<password>'              # Used to access the AMQP-queue and its FE
vnc_pass        = '<password>'              # Used to connect to the local VNC server

rails_keybase   = '<a-long-unique-key>'     # Used for rails' session management
admin_email     = '<your-email-address>'    # Serves as admin login to the rails FE
admin_fullname  = '<your-full-name>'        # The admin's full name
admin_password  = '<password>'              # Used as password for FE-login
admin_secret    = '0000'                    # Used as SIP secret for asterisk login
admin_name      = '999'                     # The admin's SIP extension/name
```


#### First steps with using the Voice platform

For convenient interaction with the VM, add its IP address and hostname -

```
* to your /etc/hosts file:
  33.33.33.100 voice01.wimdu.com

* to your ~/.ssh/config file:
  Host voice01
    HostName voice01.wimdu.com
    IdentityFile ~/.vagrant.d/insecure_private_key
    User vagrant
```

and include the [certs/server.crt](/certs/server.crt) with your SSL-key management.

**Be aware, that the provided SSL certificate is publicly available and gives no real security.**
You can easily replace it by your own after the initial provisioning, if you wish.

Now you should be able to open the [Voice platform frontend](https://voice01.wimdu.com) with your browser and log in as admin user.
For the time being, only the latest versions of Chrome and Firefox are supported, because we make use of their WebRTC- and SSE-features.

Please head over to the [Voice wiki](https://github.com/fwoeck/voice/wiki) to see
how you can register your SIP phones and make the first test calls!


#### Building the base box with [Veewee](https://github.com/jedi4ever/veewee) (optional)

tbd.


### Installation on a physical host

Although running the Voice stack in a VM is handy to get a first impression, it's not sufficient for production use -
primarily for performance reasons.

Setting up the Voice stack on a physical host is not much different than the installation to a VM.
You can follow the [Veewee](https://github.com/jedi4ever/veewee)-scripts in [/vagrant.box](/vagrant.box),
that were used to prepare a base image for Vagrant. To get the Chef-client configured, copy the [/seeds](/seeds)
contents to /etc/chef/ on the host and modify node.json and solo.rb according to your needs.

tbd.


## Technical Details

See the [voice-infrastructure](/docs/voice-infrastructure.svg) .svg for a draft overview of the service components.

tbd.


## Contributing

tbd.


## License

Wimdu Voice is released under the [MIT License](LICENSE).
