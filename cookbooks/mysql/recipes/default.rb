service 'mysql' do
  provider Chef::Provider::Service::Upstart
  supports restart: true, stop: true, start: true
  action   [:enable, :start]
end

template '/etc/mysql/my.cnf' do
  source 'my.cnf.erb'
  mode 00644

  notifies :restart, 'service[mysql]', :immediately
end

bash 'create_wim_environment' do
  user 'root'

  SQL = <<-EOS
    CREATE USER '#{node[:mysql][:wim_user]}'@'localhost' IDENTIFIED BY '#{node[:mysql][:wim_pass]}';
    GRANT ALL PRIVILEGES ON *.* TO '#{node[:mysql][:wim_user]}'@'localhost' WITH GRANT OPTION;

    CREATE USER '#{node[:mysql][:wim_user]}'@'%' IDENTIFIED BY '#{node[:mysql][:wim_pass]}';
    GRANT ALL PRIVILEGES ON *.* TO '#{node[:mysql][:wim_user]}'@'%' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
  EOS

  code <<-EOH
    mysqladmin -uroot password #{node[:mysql][:root_pass]}
    echo "#{SQL}" | mysql mysql -uroot -p#{node[:mysql][:root_pass]}
  EOH

  not_if "mysqlshow -u#{node[:mysql][:wim_user]} -p#{node[:mysql][:wim_pass]} | grep -q mysql"
end

cookbook_file '/etc/mysql/asterisk.sql' do
  owner node[:wim][:user]
  mode 00600
end

bash 'create_asterisk_schema' do
  user 'root'

  code <<-EOH
    mysql -uroot -p#{node[:mysql][:root_pass]} -e 'CREATE DATABASE asterisk CHARACTER SET utf8 COLLATE utf8_general_ci;' 2>/dev/null
    mysql asterisk -uroot -p#{node[:mysql][:root_pass]} < /etc/mysql/asterisk.sql
  EOH

  not_if "mysqlshow asterisk -u#{node[:mysql][:wim_user]} -p#{node[:mysql][:wim_pass]} | grep -q users"
end
