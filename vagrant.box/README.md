This builds a VirtualBox base-image with Veewee.
Most stuff was taken from here: https://github.com/phusion/open-vagrant-boxes

```
> cd vagrant.box
> bundle install --path=vendor
> bundle exec rake virtualbox:voice-base:all
```
