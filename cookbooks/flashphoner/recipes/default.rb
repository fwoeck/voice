cookbook_file "#{Chef::Config['file_cache_path']}/flapho_script" do
  source 'flapho_script'
  mode 00755
end

tar_name = "#{node[:flashphoner][:basename]}-#{node[:flashphoner][:version]}"

remote_file "#{Chef::Config['file_cache_path']}/#{tar_name}.tgz" do
  source "#{node[:aws][:cdn]}/#{tar_name}.tgz"
  notifies :run, 'bash[install_flashphoner]', :immediately
end

bash 'install_flashphoner' do
  user 'root'
  cwd   Chef::Config['file_cache_path']

  code <<-EOH
    export PATH=#{node[:jdk][:home]}/bin:$PATH
    rm -rf /usr/local/#{node[:flashphoner][:basename]}*
    tar -zxf #{tar_name}.tgz

    cd #{tar_name}
    ../flapho_script
    cd ..
    rm -rf #{tar_name}

    chown -R #{node[:wim][:user]}.#{node[:wim][:group]} /usr/local/#{tar_name}
  EOH

  action :nothing
end

directory "/usr/local/#{tar_name}" do
  owner node[:wim][:user]
  group node[:wim][:group]
  mode  00750
end

cookbook_file "/usr/local/#{tar_name}/conf/log4j.properties" do
  source 'log4j.properties'
  owner node[:wim][:user]
  group node[:wim][:group]

  notifies :run, 'execute[restart_flashphoner]', :delayed
end

template "/usr/local/#{tar_name}/conf/server.properties" do
  source 'server.properties.erb'
  owner node[:wim][:user]
  group node[:wim][:group]

  notifies :run, 'execute[restart_flashphoner]', :delayed
end

template "/usr/local/#{tar_name}/conf/flashphoner.properties" do
  source 'flashphoner.properties.erb'
  owner node[:wim][:user]
  group node[:wim][:group]

  notifies :run, 'bash[restart_flashphoner]', :delayed
end

bash 'restart_flashphoner' do
  user 'root'

  code <<-EOH
    sv t flashphoner
  EOH

  action :nothing
end

directory '/etc/sv/flashphoner' do
  mode 00755
end

template '/etc/sv/flashphoner/run' do
  source 'run.erb'
  mode 00755
end

link '/etc/service/flashphoner' do
  to '/etc/sv/flashphoner'
end
