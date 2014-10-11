# How to build a VirtualBox base-image for Voice

## Downloads a prebuilt base box:

Prerequisites:
- VirtualBox with Extension Pack
- Vagrant with vagrant-omnibus Plugin
- ruby2 for building the Vagrant box

```
> git clone git://github.com/fwoeck/voice.git
> cd voice
> cp Vagrantfile.example Vagrantfile
> vagrant up
```

## Build the base box on your own:

```
> cd vagrant.box
> bundle install --path=vendor
> chmod 600 vagrant_insecure.key
> bundle exec rake virtualbox:voice-base:all
```
