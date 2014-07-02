tar_name = "tmux-#{node[:tmux][:version]}"

remote_file "#{Chef::Config['file_cache_path']}/#{tar_name}.tar.gz" do
  source "#{node[:aws][:cdn]}/#{tar_name}.tar.gz"
  notifies :run, 'bash[install_tmux]', :immediately
end

bash 'install_tmux' do
  user 'root'
  cwd   Chef::Config['file_cache_path']

  code <<-EOH
    tar -zxf #{tar_name}.tar.gz
    cd #{tar_name}
    ./configure && make -j3 && make install
    cd ..
    rm -rf #{tar_name}
  EOH

  action :nothing
end

cookbook_file '/etc/tmux.conf' do
  source 'tmux.conf'
  mode    00644

  not_if { File.exists?('/etc/tmux.conf') }
end

bash 'install_wemux' do
  user 'root'
  cwd   Chef::Config['file_cache_path']

  code <<-EOH
    git clone git://github.com/zolrath/wemux.git /usr/local/share/wemux
    ln -s /usr/local/share/wemux/wemux /usr/local/bin/wemux
  EOH

  not_if { File.exists?('/usr/local/bin/wemux') }
end

template '/usr/local/etc/wemux.conf' do
  source 'wemux.conf.erb'
  owner  'root'
end
