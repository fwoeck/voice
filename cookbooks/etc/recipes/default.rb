template '/etc/environment' do
  source 'environment.erb'
  mode 00644
end

cookbook_file '/etc/updatedb.conf' do
  source 'updatedb.conf'
  mode 00644
end

template '/etc/hosts' do
  source 'hosts.erb'
  mode 00644
end

template '/etc/cron.daily/00logwatch' do
  source '00logwatch.erb'
  mode 00755
end

cookbook_file '/usr/share/logwatch/default.conf/logwatch.conf' do
  source 'logwatch.conf'
  mode 00644
end

file '/etc/hostname' do
  content node[:hostname][/[^.]+/] + "\n"
  mode 00644
end

ruby_block 'edit_ld_so_conf' do
  block do
    file = Chef::Util::FileEdit.new('/etc/ld.so.conf')
    file.insert_line_if_no_match(/^\/usr\/local\/lib/, '/usr/local/lib')
    file.write_file
  end

  not_if 'grep -q "/usr/local/lib" /etc/ld.so.conf'
end

template '/etc/iptables/rules.v4' do
  source 'iptables.rules.erb'
  mode 00440

  notifies :restart, 'service[iptables-persistent]', :immediately
end

service 'iptables-persistent' do
  supports restart: true, stop: true, start: true
  action  :enable

  notifies :restart, 'service[fail2ban]', :delayed
end

cookbook_file '/etc/sudoers' do
  source 'sudoers'
  mode 00440
end

cookbook_file '/etc/default/rcS' do
  source 'rcS'
  mode 00644
end

service 'ntp' do
  supports restart: true, stop: true, start: true
  action  :enable
end

template '/etc/crontab' do
  source 'crontab.erb'
  mode 00644
end

template '/etc/zsh/zshenv' do
  source 'zshenv.erb'
  mode 00755
end

ruby_block 'edit_useradd' do
  block do
    f = Chef::Util::FileEdit.new('/etc/default/useradd')
    f.search_file_replace_line(/SHELL=/, 'SHELL=/bin/bash'); f.write_file
    f.search_file_replace_line(/CREATE_MAIL_SPOOL/, 'CREATE_MAIL_SPOOL=yes'); f.write_file
  end

  not_if 'grep -q SHELL=.bin.bash /etc/default/useradd'
end

remote_file "#{Chef::Config['file_cache_path']}/dkm-skel.tgz" do
  source  "#{node[:aws][:cdn]}/dkm-skel.tgz"
  checksum node[:etc][:skel_sum]
end

bash 'fetch_etc_skel' do
  user  'root'
  cwd   '/etc'

  code <<-EOH
    rm -rf skel
    tar xzf #{Chef::Config['file_cache_path']}/dkm-skel.tgz
  EOH

  not_if 'test -e /etc/skel/bin'
end

template '/etc/rc.local' do
  source 'rc.local.erb'
  mode 00755
end

cookbook_file '/etc/sysctl.conf' do
  source 'sysctl.conf'
  mode 00644

  notifies :run, 'bash[set_sysctl]', :immediately
end

bash 'set_sysctl' do
  user 'root'
  command 'sysctl -p'
  action :nothing
end

cookbook_file '/etc/default/grub' do
  source 'grub'
  mode 00644

  notifies :run, 'bash[update_grub]', :immediately
end

bash 'update_grub' do
  user 'root'
  command 'update-grub'
  action :nothing
end

service 'ssh' do
  provider Chef::Provider::Service::Upstart
  supports restart: true, stop: true, start: true
  action   [:enable, :start]
end

service 'fail2ban' do
  supports restart: true, stop: true, start: true
  action   :enable
end

template '/etc/fail2ban/jail.conf' do
  source 'jail.conf.erb'
  mode 00644
end

cookbook_file '/etc/fail2ban/filter.d/asterisk-tcp.conf' do
  source 'asterisk-tcp.conf'
  mode 00644
end

cookbook_file '/etc/fail2ban/filter.d/asterisk-udp.conf' do
  source 'asterisk-udp.conf'
  mode 00644
end

cookbook_file '/etc/ssh/ssh_config' do
  source 'ssh_config'
  mode 00644
end

cookbook_file '/etc/ssh/sshd_config' do
  source 'sshd_config'
  mode 00644

  notifies :restart, 'service[ssh]', :delayed
end
