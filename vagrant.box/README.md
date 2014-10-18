### How to build a VirtualBox base-image for the Voice platform

For the prerequisites, please refer to the [Voice main-repo](https://github.com/fwoeck/voice#prerequisites).
Also, you'll need a MRI ruby 2.1 for the Veewee-gem installation.

```
> git clone git://github.com/fwoeck/voice.git
> cd voice/vagrant.box
> bundle install --path=vendor
> chmod 600 vagrant_insecure.key
> vagrant box remove voice-base
> bundle exec rake virtualbox:voice-base:all
```

These steps will download the Ubuntu 14.04 distribution, compile the Voice base-image and register it with
Vagrant, so that it's used when you start the initial VM provisioning.
