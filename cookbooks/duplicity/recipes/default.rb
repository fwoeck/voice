package 'python-boto'
package 'duplicity'
package 'duply'

directory '/root/.duply' do
  owner 'root'
  group 'root'
end

directory "/root/.duply/#{node[:hostname][/[^.]+/]}" do
  owner 'root'
  group 'root'
  mode   00700
end

cookbook_file "/root/.duply/#{node[:hostname][/[^.]+/]}/exclude" do
  source 'exclude'
  mode    00644
end

template "/root/.duply/#{node[:hostname][/[^.]+/]}/conf" do
  source 'conf.erb'
  mode    00644
end

cron 'weekly_s3_backup' do
  minute  '38'
  hour    '4'
  weekday '0'

  command "/usr/bin/duply #{node[:hostname][/[^.]+/]} backup >/dev/null"
  not_if { node[:roles].include?('desktop') }
end
