tar_name = "jdk#{node[:jdk][:version]}"

remote_file "#{Chef::Config['file_cache_path']}/#{tar_name}.tar.gz" do
  source "#{node[:aws][:cdn]}/#{tar_name}.tar.gz"
  not_if "test -e #{Chef::Config['file_cache_path']}/#{tar_name}.tar.gz"
  notifies :run, 'bash[install_jdk]', :immediately
end

bash 'install_jdk' do
  user 'root'
  cwd   Chef::Config['file_cache_path']

  code <<-EOH
    tar -zxf #{tar_name}.tar.gz
    rm -rf #{node[:jdk][:home]}
    mv #{tar_name} #{node[:jdk][:home]}
    #{node[:jdk][:home]}/bin/java -Xshare:dump
    chown -R #{node[:wim][:user]}:#{node[:wim][:group]} #{node[:jdk][:home]}
  EOH

  action :nothing
end

directory "#{node[:wim][:home]}/.mozilla" do
  owner node[:wim][:user]
  group node[:wim][:group]
  mode  00755
end

directory "#{node[:wim][:home]}/.mozilla/plugins" do
  owner node[:wim][:user]
  group node[:wim][:group]
  mode  00755
end

bash 'install_mozilla_java_plugin' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:wim][:home]

  code <<-EOH
    ln -s #{node[:jdk][:home]}/jre/lib/amd64/libnpjp2.so #{node[:wim][:home]}/.mozilla/plugins/libnpjp2.so
  EOH

  not_if "test -e #{node[:wim][:home]}/.mozilla/plugins/libnpjp2.so"
end

jmc_config = "#{node[:jdk][:home]}/lib/missioncontrol/configuration/config.ini"

ruby_block 'edit_mission_control' do
  block do
    file = Chef::Util::FileEdit.new(jmc_config)
    file.insert_line_if_no_match(/mozilla/, 'org.eclipse.swt.browser.DefaultType=mozilla')
    file.write_file
  end

  not_if "grep -q mozilla #{jmc_config}"
end
