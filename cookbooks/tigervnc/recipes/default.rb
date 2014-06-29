tar_name = "tigervnc-Linux-x86_64-#{node[:vnc][:version]}"

remote_file "#{Chef::Config['file_cache_path']}/#{tar_name}.tar.gz" do
  source "#{node[:aws][:cdn]}/#{tar_name}.tar.gz"

  not_if "test -e #{Chef::Config['file_cache_path']}/#{tar_name}.tar.gz"
  notifies :run, 'bash[install_tigervnc]', :immediately
end

bash 'install_tigervnc' do
  user 'root'
  cwd   Chef::Config['file_cache_path']

  code <<-EOH
    rm -rf #{node[:vnc][:basedir]} 2>/dev/null
    mkdir -p #{node[:vnc][:basedir]}
    cd #{node[:vnc][:basedir]}

    tar xzf #{Chef::Config['file_cache_path']}/#{tar_name}.tar.gz
    mv ./usr/* .
    rm -rf usr etc
  EOH

  action :nothing
end

template "#{node[:wim][:home]}/bin/vnc" do
  source 'vnc.erb'
  mode    00755
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

directory "#{node[:wim][:home]}/.vnc" do
  owner node[:wim][:user]
  group node[:wim][:group]
  mode  0750
end

bash 'create_vnc_password' do
  user  node[:wim][:user]
  group node[:wim][:group]

  code <<-EOH
    echo #{node[:vnc][:password]} | #{node[:vnc][:basedir]}/bin/vncpasswd -f > #{node[:wim][:home]}/.vnc/passwd
    chmod 640 #{node[:wim][:home]}/.vnc/passwd
  EOH

  not_if "test -e #{node[:wim][:home]}/.vnc/passwd"
end
