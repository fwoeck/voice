## How to build a VirtualBox base-image for Voice

### Downloads a prebuilt base box:

Prerequisites:

- VirtualBox with Extension Pack (v 4.3.18)
- Vagrant with vagrant-omnibus Plugin (v 1.6.5, plugin 1.4.1)
- ruby2.1 for building the Vagrant box

```
> git clone git://github.com/fwoeck/voice.git
> cd voice
> cp Vagrantfile.example Vagrantfile
> vi Vagrantfile
> vagrant plugin install vagrant-omnibus
> vagrant up
```

### Build the base box on your own:

```
> cd vagrant.box
> bundle install --path=vendor
> chmod 600 vagrant_insecure.key
> vagrant box remove voice-base
> bundle exec rake virtualbox:voice-base:all
```
