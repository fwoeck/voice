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

template '/root/bin/s3_backup' do
  source 's3_backup.erb'
  mode    00755
end

cron 'weekly_s3_backup' do
  minute  '38'
  hour    '4'
  weekday '0'

  command '/root/bin/s3_backup'
  only_if { node[:aws][:s3_backup] }
end
