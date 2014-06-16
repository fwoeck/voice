execute 'add-10gen-key' do
  command 'apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10'
  action  :run

  not_if { File.exists?('/usr/bin/mongo') }
end

file '/etc/apt/sources.list.d/10gen.list' do
  content "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen\n"
  mode    00644
end

execute 'update-apt-mongo' do
  command 'apt-get update'
  action  :run

  not_if { File.exists?('/usr/bin/mongo') }
end

package 'mongodb-org'

service 'mongod' do
  provider Chef::Provider::Service::Upstart
  supports restart: true, stop: true, start: true
  action   [:enable, :start]
end

cookbook_file '/etc/mongod.conf' do
  source 'mongod.conf'
  owner  'root'
  mode    00644

  notifies :restart, 'service[mongod]', :immediately
end

cron 'purge_mongo_logs' do
  minute  '38'
  hour    '3'
  weekday '0'
  command %q{kill -USR1 $(pidof mongod)}
end

cron 'repair_mongo_db' do
  minute  '38'
  hour    '1'
  weekday '0'
  command "/usr/bin/mongo #{node[:mongodb][:db][node[:etc][:railsenv]]} --eval 'db.repairDatabase();' >/dev/null"
end
