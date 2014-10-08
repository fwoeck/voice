execute 'apt-upgrade' do
  command 'apt-get update && apt-get -q -y upgrade'

  not_if do
    File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
      File.mtime('/var/lib/apt/periodic/update-success-stamp') > Time.now - 86400
  end
end

%w{
  at
  ant
  aptitude
  autoconf
  automake
  binutils-doc
  bison
  bridge-utils
  build-essential
  ca-certificates
  chromium-browser
  chrpath
  cmake
  curl
  dkms
  dstat
  expect
  exuberant-ctags
  fail2ban
  flex
  freetds-dev
  g++
  gawk
  git
  git-core
  git-flow
  htop
  imagemagick
  iptables-persistent
  libasound2-dev
  libboost-filesystem-dev
  libboost-thread-dev
  libcurl4-openssl-dev
  libevent-dev
  libffi-dev
  libfontconfig1-dev
  libfreetype6-dev
  libgdbm-dev
  libgeoip-dev
  libgmime-2.6-dev
  libgpgme11-dev
  libiksemel3
  libjpeg-dev
  libmysqlclient-dev
  libncurses5-dev
  libncursesw5-dev
  libopenjpeg-dev
  libpng12-dev
  libpth20
  libradiusclient-ng2
  libreadline-dev
  libresample1-dev
  libsasl2-2
  libsasl2-modules
  libsox-fmt-alsa
  libsox-fmt-base
  libsox-fmt-mp3
  libsox2
  libspeex-dev
  libspeexdsp-dev
  libsqlite0-dev
  libsqlite3-dev
  libsrtp0-dev
  libssl-dev
  libtiff5-dev
  libtool
  libxext-dev
  libxft-dev
  libxml2-dev
  libxrender-dev
  libxslt1-dev
  libyaml-dev
  linux-lowlatency
  logwatch
  mailutils
  module-assistant
  mosh
  mysql-server
  mytop
  ngrep
  nmap
  ntp
  perl
  pixz
  python
  python-gamin
  python-magic
  python-numpy
  python-pyinotify
  python-software-properties
  remmina
  runit
  s3cmd
  scons
  sox
  sqlite3
  ssh-askpass
  subversion
  tree
  unixodbc-dev
  x11vnc
  xvfb
  zlib1g-dev
  zsh
}.each {|pkg| package pkg }

bash 'remove_some_packages' do
  code <<-EOH
    apt-get -y purge modemmanager whoopsie libwhoopsie0 kerneloops-daemon "bluez*"
    apt-get autoremove
  EOH

  only_if 'dpkg -l | grep -q modemmanager'
end

bash 'remove_apparmor' do
  code <<-EOH
    service apparmor stop
    update-rc.d -f apparmor remove
    apt-get -y remove apparmor
  EOH

  only_if 'test -e /lib/apparmor/functions'
end
