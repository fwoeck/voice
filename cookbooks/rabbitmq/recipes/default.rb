remote_file "#{Chef::Config['file_cache_path']}/rabbitmq-signing-key-public.asc" do
  source "http://www.rabbitmq.com/rabbitmq-signing-key-public.asc"
  notifies :run, 'bash[install_rabbitmq_key]', :immediately
end

bash 'install_rabbitmq_key' do
  user 'root'
  cwd   Chef::Config['file_cache_path']

  code 'apt-key add rabbitmq-signing-key-public.asc'
  action :nothing
end

file '/etc/apt/sources.list.d/rabbitmq.list' do
  content "deb http://www.rabbitmq.com/debian/ testing main\n"
  mode     00644
end

execute 'update-apt-rabbit' do
  command 'apt-get update'
  action  :run

  not_if { File.exists?('/usr/sbin/rabbitmqctl') }
end

package 'rabbitmq-server'

service 'rabbitmq-server' do
  supports restart: true, stop: true, start: true
  action   [:enable, :start]
end

file '/etc/rabbitmq/enabled_plugins' do
  content "[rabbitmq_management].\n"
  mode     00644

  notifies :restart, 'service[rabbitmq-server]', :immediately
end

bash 'setup_admin_user' do
  user 'root'

  code <<-EOH
    rabbitmqctl add_user #{node[:rabbitmq][:user]} #{node[:rabbitmq][:pass]}
    rabbitmqctl set_permissions #{node[:rabbitmq][:user]} ".*" ".*" ".*"
    rabbitmqctl set_user_tags #{node[:rabbitmq][:user]} administrator
    rabbitmqctl delete_user guest
  EOH

  not_if "test $(rabbitmqctl list_users | grep #{node[:rabbitmq][:user]} | wc -l) -gt 0"
end
