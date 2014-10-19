tar_name = "elasticsearch-#{node[:elasticsearch][:version]}"

remote_file "#{Chef::Config['file_cache_path']}/#{tar_name}.tar.gz" do
  source "#{node[:aws][:cdn]}/#{tar_name}.tar.gz"
  notifies :run, 'bash[install_elasticsearch]', :immediately
end

bash 'install_elasticsearch' do
  user 'root'
  cwd   Chef::Config['file_cache_path']

  code <<-EOH
    tar -zxf #{tar_name}.tar.gz

    if [ -e #{node[:elasticsearch][:basedir]}/data ]; then
      mv #{node[:elasticsearch][:basedir]}/data #{Chef::Config['file_cache_path']}
    fi

    rm -rf #{node[:elasticsearch][:basedir]}
    mv #{tar_name} #{node[:elasticsearch][:basedir]}
    chown -R #{node[:wim][:user]}.#{node[:wim][:group]} #{node[:elasticsearch][:basedir]}

    if [ -e #{Chef::Config['file_cache_path']}/data ]; then
      mv #{Chef::Config['file_cache_path']}/data #{node[:elasticsearch][:basedir]}
    fi
  EOH

  action :nothing
end

directory node[:elasticsearch][:basedir] do
  owner node[:wim][:user]
  group node[:wim][:group]
  mode  00750
end

directory "#{node[:elasticsearch][:basedir]}/logs" do
  owner node[:wim][:user]
  group node[:wim][:group]
  mode  00750
end

cookbook_file "#{node[:elasticsearch][:basedir]}/config/elasticsearch.yml" do
  source 'elasticsearch.yml'
  owner node[:wim][:user]
  group node[:wim][:group]
end

directory "#{node[:etc][:logdir]}/elasticsearch" do
  recursive true
  mode 00755
end

directory '/etc/sv/elasticsearch' do
  mode 00755
end

template '/etc/sv/elasticsearch/run' do
  source 'srv_run.erb'
  mode 00755
end

directory '/etc/sv/elasticsearch/log' do
  mode 00755
end

template '/etc/sv/elasticsearch/log/run' do
  source 'log_run.erb'
  mode 00755
end

link '/etc/service/elasticsearch' do
  to '/etc/sv/elasticsearch'
end

cron 'optimize_elasticsearch_indiecs' do
  minute  '28'
  hour    '1'
  weekday '0'
  command "curl -s #{node[:elasticsearch][:host]}:#{node[:elasticsearch][:port]}/_cat/indices | awk '{print $2}' | while read IND; do curl -s -XPOST http://#{node[:elasticsearch][:host]}:#{node[:elasticsearch][:port]}/$IND/_optimize >/dev/null; done"
end
