group 'asterisk' do
end

user 'asterisk' do
  gid   'asterisk'
  shell '/usr/sbin/nologin'
end

opus_name = "opus-#{node[:opus][:version]}"

remote_file "#{Chef::Config['file_cache_path']}/#{opus_name}.tar.gz" do
  source "#{node[:aws][:cdn]}/#{opus_name}.tar.gz"
  not_if "test -e #{Chef::Config['file_cache_path']}/#{opus_name}.tar.gz"

  notifies :run, 'bash[install_opus]', :immediately
end

bash 'install_opus' do
  user 'root'
  cwd   Chef::Config['file_cache_path']

  code <<-EOH
    rm /usr/sbin/asterisk 2>/dev/null
    tar -zxf #{opus_name}.tar.gz
    cd #{opus_name}
    ./configure
    make && make install
    cd ..
    rm -rf #{opus_name}
  EOH

  notifies :run, 'bash[install_asterisk]', :delayed
  action :nothing
end

tar_name = "asterisk-#{node[:asterisk][:version]}"

remote_file "#{Chef::Config['file_cache_path']}/#{tar_name}.tar.gz" do
  source "#{node[:aws][:cdn]}/#{tar_name}.tar.gz"
  not_if "test -e #{Chef::Config['file_cache_path']}/#{tar_name}.tar.gz"
end

cookbook_file "#{Chef::Config['file_cache_path']}/asterisk-opus.diff" do
  source 'asterisk-opus.diff'
  notifies :run, 'bash[install_asterisk]', :delayed
end

remote_file "#{Chef::Config['file_cache_path']}/ast-sounds.tgz" do
  source "#{node[:aws][:cdn]}/ast-sounds.tgz"
  not_if "test -e #{Chef::Config['file_cache_path']}/ast-sounds.tgz"
end

bash 'install_asterisk' do
  user 'root'
  cwd   Chef::Config['file_cache_path']

  code <<-EOH
    export CFLAGS=""
    tar -zxf #{tar_name}.tar.gz
    cd #{tar_name}
    patch -p1 < ../asterisk-opus.diff
    ./bootstrap.sh
    make clean && ./configure --with-crypto --with-ssl --with-srtp --with-mysqlclient
    make -C menuselect
    make menuselect-tree
    menuselect/menuselect --disable-category MENUSELECT_CORE_SOUNDS menuselect.makeopts || :
    menuselect/menuselect --disable-category MENUSELECT_MOH menuselect.makeopts || :
    menuselect/menuselect --disable-category MENUSELECT_EXTRA_SOUNDS menuselect.makeopts || :
    menuselect/menuselect --enable format_mp3 menuselect.makeopts || :
    menuselect/menuselect --enable res_config_mysql menuselect.makeopts || :
    ./contrib/scripts/get_mp3_source.sh
    make -j4 && make install && make samples
    cd ..
    rm -rf #{tar_name}
  EOH

  not_if {
    File.exists?('/usr/sbin/asterisk') &&
    `/usr/sbin/asterisk -V`[/#{node[:asterisk][:version]}/]
  }
end

bash 'install_soundfiles' do
  user 'root'

  code <<-EOH
    cd /var/lib/asterisk
    rm -rf sounds
    tar -zxf #{Chef::Config['file_cache_path']}/ast-sounds.tgz
  EOH

  not_if  'test -e /var/lib/asterisk/sounds/en'
  only_if 'test -e /var/lib/asterisk'
end

cookbook_file '/etc/init.d/asterisk' do
  source 'initd_asterisk'
  mode 00755
end

cookbook_file '/etc/default/asterisk' do
  source 'default_asterisk'
  mode 00644
end

directory '/var/log/asterisk' do
  owner 'asterisk'
end

directory '/var/log/asterisk/cdr-csv' do
  owner 'asterisk'
end

directory '/var/run/asterisk' do
  owner 'asterisk'
end

directory '/var/punchblock' do
  owner node[:wim][:user]
  mode 00750
end

directory '/var/punchblock/record' do
  owner node[:wim][:user]
end

directory '/var/spool/asterisk' do
  owner 'asterisk'
end

directory '/var/lib/asterisk' do
  owner 'asterisk'
end

remote_file '/usr/lib/asterisk/modules/codec_g729.so' do
  source  "#{node[:aws][:cdn]}/codec_g729.so"
  checksum node[:asterisk][:g729_checksum]
  mode     00644
end

cookbook_file '/etc/asterisk/logger.conf' do
  source 'logger.conf'
  owner  'asterisk'
  mode    00640

  notifies :run, 'execute[restart-asterisk]', :delayed
end

cookbook_file '/etc/asterisk/confbridge.conf' do
  source 'confbridge.conf'
  owner  'asterisk'
  mode    00640

  notifies :run, 'execute[restart-asterisk]', :delayed
end

cookbook_file '/etc/asterisk/extconfig.conf' do
  source 'extconfig.conf'
  owner  'asterisk'
  mode    00640

  notifies :run, 'execute[restart-asterisk]', :delayed
end

cookbook_file '/etc/asterisk/modules.conf' do
  source 'modules.conf'
  owner  'asterisk'
  mode    00640

  notifies :run, 'execute[restart-asterisk]', :delayed
end

cookbook_file '/etc/asterisk/extensions.conf' do
  source 'extensions.conf'
  owner  'asterisk'
  mode    00640

  notifies :run, 'execute[restart-asterisk]', :delayed
end

template '/etc/asterisk/manager.conf' do
  source 'manager.conf.erb'
  owner  'asterisk'
  mode    00640

  notifies :run, 'execute[restart-asterisk]', :delayed
end

template '/etc/asterisk/res_config_mysql.conf' do
  source 'res_config_mysql.conf.erb'
  owner  'asterisk'
  mode    00640

  notifies :run, 'execute[restart-asterisk]', :delayed
end

template '/etc/asterisk/sip.conf' do
  source 'sip.conf.erb'
  owner  'asterisk'
  mode    00640

  notifies :run, 'execute[restart-asterisk]', :delayed
end

cookbook_file '/etc/asterisk/asterisk.pem' do
  source 'asterisk.pem'
  owner  'asterisk'
  mode 00600

  notifies :run, 'execute[restart-asterisk]', :delayed
end

cookbook_file '/etc/asterisk/ca.crt' do
  source 'ca.crt'
  owner  'asterisk'
  mode 00644

  notifies :run, 'execute[restart-asterisk]', :delayed
end

service 'asterisk' do
  supports restart: true, stop: true, start: true
  action   [:enable, :start]
end

remote_directory '/var/lib/asterisk/sounds/wimdu' do
  files_mode 00644
end

execute 'restart-asterisk' do
  command 'asterisk -rx "core restart gracefully"'
  action :nothing
end
