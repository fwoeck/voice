Wimdu Voice is an IP telephony distribution that aims to provide many workflow elements
needed by call center agents and supervisors in one integrated platform.

It offers a fully automated but customizable installation and contains all necessary layers
like the SIP server and a modern, easy to use web interface.

##### Platform services (see details [below](#the-platform-service-structure))

[![Code Climate](https://codeclimate.com/github/fwoeck/voice-ahn/badges/gpa.svg)](https://codeclimate.com/github/fwoeck/voice-ahn) [Voice-Ahn](https://github.com/fwoeck/voice-ahn)  
[![Code Climate](https://codeclimate.com/github/fwoeck/voice-custom/badges/gpa.svg)](https://codeclimate.com/github/fwoeck/voice-custom) [Voice-Custom](https://github.com/fwoeck/voice-custom)  
[![Code Climate](https://codeclimate.com/github/fwoeck/voice-numbers/badges/gpa.svg)](https://codeclimate.com/github/fwoeck/voice-numbers) [Voice-Numbers](https://github.com/fwoeck/voice-numbers)  
[![Code Climate](https://codeclimate.com/github/fwoeck/voice-push/badges/gpa.svg)](https://codeclimate.com/github/fwoeck/voice-push) [Voice-Push](https://github.com/fwoeck/voice-push)  
[![Code Climate](https://codeclimate.com/github/fwoeck/voice-rails/badges/gpa.svg)](https://codeclimate.com/github/fwoeck/voice-rails) [Voice-Rails](https://github.com/fwoeck/voice-rails)


## Overview

Watch a 7min feature walkthrough [on youtube](http://www.youtube.com/watch?feature=player_embedded&v=G4323t5HzuM):

<a href='http://www.youtube.com/watch?feature=player_embedded&v=G4323t5HzuM' target='_blank'><img src='http://img.youtube.com/vi/G4323t5HzuM/0.jpg' alt='Voice platform intro' width='160' height='120' /></a>


These are the key functionalities of the Voice stack:

* The server can be connected to an external SIP provider/Skype to receive calls and dial out.
* Callers/customers are led by an IVR that allows to choose among different languages and topics.
* Customers are scheduled to those agents, that match the requested skills and are currently idle.
* Agents can configure the language- and topic-support according to their individual skills.
* The platform creates customer records and history entries and shows them during the call.
* Calls can be tagged and remarked for later callbacks and post processing.
* The history can be searched for unfinished tasks and serves as starting point for outbound calls.
* Customers can be connected to Zendesk and their current tickets can by synchronized.
* Agents can use SIP phones (hardware/software) or the browser's WebRTC (license required).
* The platform provides realtime statistics and aggregated logging and charts for accounting.

Some technical characteristics:

* The distribution is based on Ubuntu 14.04 LTS and is tailored to run on one machine/host.
* Configuration is fully driven by Opscode Chef, so installation and customization is easy.
* The platform can be automatically deployed to a VirtualBox VM for development and testing.
* To get started, only a handful of options have to be set, no external SIP provider is required.
* The supported languages and topics/skills can be freely changed (sound samples required).
* The linux OS provides service supervision, firewall protection, logging and backup facilities.

These are some of the core technologies in use:

[Adhearsion](http://www.adhearsion.com), [Asterisk](http://www.asterisk.org), [Celluloid](https://celluloid.io), [Chef-solo](https://www.getchef.com/chef/), 
[Duplicity](http://duplicity.nongnu.org), [Elasticsearch](http://www.elasticsearch.org), [Ember.js](http://emberjs.com), 
[Java JDK](http://www.oracle.com/technetwork/java/javase/overview/index.html), [MRI ruby](https://www.ruby-lang.org/) & [jRuby](http://jruby.org), 
[MongoDB](http://www.mongodb.org), [MySQL](http://www.mysql.com), [Nginx](http://nginx.org), [RabbitMQ](http://www.rabbitmq.com), 
[Rails](http://rubyonrails.org), [Redis](http://redis.io), [Ubuntu](http://www.ubuntu.com), [Vagrant](https://www.vagrantup.com), 
[VirtualBox](https://www.virtualbox.org)


## Screenshots

Incoming call pane: the default view for an agent when a customer calls in.
You can see the customer's history and the latest CRM tickets.

<img src="/images/voice-08.png" alt="voice-08" width="341" height="277">
<img src="/images/voice-02.png" alt="voice-02" width="341" height="277">

Customer history search: agents can look for specific calls, pending tickets or mailbox messages here.
They can update entry states or use them to do outbound calls.

<img src="/images/voice-03.png" alt="voice-03" width="341" height="277">
<img src="/images/voice-04.png" alt="voice-04" width="341" height="277">

Statistical overview: this gives a broad summary of the current call situation and shows details for teams.
Calls and timings are aggregated for the last 24h.

<img src="/images/voice-05.png" alt="voice-05" width="341" height="277">
<img src="/images/voice-01.png" alt="voice-01" width="341" height="277">

Agent preference settings: this is where agents go to adjust their profile and admins add new agents.
The supported languages and skills are freely customizable.

<img src="/images/voice-06.png" alt="voice-06" width="341" height="277">
<img src="/images/voice-07.png" alt="voice-07" width="341" height="277">


## Project Status

**We don't consider the Voice platform to be production ready at this point.** It's being tested internally and will
very likely be modified as we see fit. As soon as things stabilize, we'll hit 1.0 and switch to semantic versioning.


## Getting Started

As the installation is fully driven by [Chef](https://www.getchef.com/chef/), trying out the platform is almost effortless.
Its as simple as cloning this repo, customizing one file and typing "vagrant up".


### Installation to a VirtualBox VM via Vagrant

#### Prerequisites

It's recommended to have at least a recent quad-core machine with 8Gbyte of free ram for things to run smoothly. Installations are
tested with OsX 10.9.5 and Ubuntu 14.04.

* Grab the latest copy of [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (currently 4.3.20), including the Extension Pack.
* Also, you'll need to install [Vagrant](https://www.vagrantup.com/downloads.html) (currently 1.7.0).

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

There are two distinct [Chef-roles](/roles) the VM can be configured for. The *desktop*-role is intended for local development of the Voice stack and
the *server*-role is meant for production use. The two environments are almost identical, except for these things:

* *desktop* uses MRI ruby 2.1 for shorter response cycles during development,
* while *server* uses jRuby 1.7 for GIL-less threading and better instrumentation.
* *desktop* uses the *vagrant*-user as primary actor whereas *server* uses *wim*.

We recommend to go with the *desktop*-default unless you want to conduct some smoke tests with the production environment.
Please refer to the [configuration table](https://github.com/fwoeck/voice/wiki/Table-of-configuration-options) for more available options including Zendesk support and VoIP
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
    User vagrant
    HostName voice01.wimdu.com
    IdentityFile ./.vagrant/machines/voice01/virtualbox/private_key
```

and include the [certs/server.crt](/certs/server.crt) to your SSL key-chain management.

**Be aware, that the provided SSL certificate is publicly available and gives no real security.**
You can easily replace it by your own after the initial provisioning.

Now you should be able to open the [Voice platform frontend](https://voice01.wimdu.com) with your browser and log in as admin user.
For the time being, only the latest versions of Chrome and Firefox are supported, because we make use of their WebRTC- and SSE-features.

Congratulations, you have the fully operational Voice platform at hand! Please head over to the
[Voice wiki](https://github.com/fwoeck/voice/wiki/Connecting-phones-and-calling) to see how you can register your SIP phones and make the first test calls.


#### Building the Ubuntu base image with Veewee (optional)

If you already installed the VM, you may have noticed that Vagrant downloaded a voice-base image (~375MB) at the beginning. This is a minimal
Ubuntu installation that we provide on our CDN to accelerate the installation.

However, the steps to compile this box are automated with [Veewee](https://github.com/jedi4ever/veewee) and you can use the
[/vagrant.box](/vagrant.box)-scripts to build you own, if you wish.


### Installation on a physical host

Although running the Voice stack in a VM is handy to get a first impression, it's usually not sufficient for production use -
primarily for performance and timing reasons.

Please consult the [Voice wiki](https://github.com/fwoeck/voice/wiki/Installation-on-a-production-host) for detailed instructions on how to install the Voice stack
on an external production host.


## The platform service structure

Apart from the underlying Ubuntu linux, the Voice stack consists of these ruby services, that are kept in separate Github repos:

* [Voice-Ahn](https://github.com/fwoeck/voice-ahn): the entry point for incoming calls, drives the IVR and controls the SIP server.
* [Voice-Custom](https://github.com/fwoeck/voice-custom): provides the basic CRM service, history/tagging and fulltext search.
* [Voice-Numbers](https://github.com/fwoeck/voice-numbers): calculates realtime statistics and aggregates the call logs.
* [Voice-Push](https://github.com/fwoeck/voice-push): sends push notifications for current events to the agent's browsers.
* [Voice-Rails](https://github.com/fwoeck/voice-rails): delivers the browser application for agents and supervisors.
* [Voice-Specs](https://github.com/fwoeck/voice-specs): not a service per se, but a tool collection for integration testing.

This diagram shows a rough overview of the communication flow and storage engines:

<img src="/images/voice-09.png" alt="voice-09" width="512" height="350">


## Contributing

tbd.


## License

Wimdu Voice is released under the [MIT License](LICENSE).
