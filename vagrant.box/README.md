# How to build a VirtualBox base-image for Voice

## Downloads a prebuilt base box:

```
> git clone git@github.com:fwoeck/voice-chef.git voice
> cd voice
> cp Vagrantfile.example Vagrantfile
> vagrant up
```

## Build the base box on your own:

```
> cd vagrant.box
> bundle install --path=vendor
> chmod 400 vagrant_insecure.key
> bundle exec rake virtualbox:voice-base:all
```
