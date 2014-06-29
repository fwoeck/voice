nginx_name = "nginx-#{node[:nginx][:version]}"

remote_file "#{Chef::Config['file_cache_path']}/#{nginx_name}.tar.gz" do
  source "#{node[:aws][:cdn]}/#{nginx_name}.tar.gz"
  owner node[:wim][:user]
end

remote_file "#{Chef::Config['file_cache_path']}/headers-more-nginx-module-#{node[:nginx][:headers][:version]}.tgz" do
  source "#{node[:aws][:cdn]}/headers-more-nginx-module-#{node[:nginx][:headers][:version]}.tgz"
  owner node[:wim][:user]
end

remote_file "#{Chef::Config['file_cache_path']}/nginx_accept_language_module.tgz" do
  source "#{node[:aws][:cdn]}/nginx_accept_language_module.tgz"
  checksum node[:nginx][:language][:checksum]
  owner node[:wim][:user]
end

remote_file "#{Chef::Config['file_cache_path']}/ngx_http_redis-#{node[:nginx][:redis][:version]}.tar.gz" do
  source "#{node[:aws][:cdn]}/ngx_http_redis-#{node[:nginx][:redis][:version]}.tar.gz"
  owner node[:wim][:user]
end

bash 'install_nginx' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:wim][:home]

  code <<-EOH
    export HOME=#{node[:wim][:home]}

    tar -zxf #{Chef::Config['file_cache_path']}/nginx_accept_language_module.tgz
    tar -zxf #{Chef::Config['file_cache_path']}/headers-more-nginx-module-#{node[:nginx][:headers][:version]}.tgz
    tar -zxf #{Chef::Config['file_cache_path']}/ngx_http_redis-#{node[:nginx][:redis][:version]}.tar.gz
    tar -xzf #{Chef::Config['file_cache_path']}/#{nginx_name}.tar.gz

    cd #{nginx_name}
    ./configure --prefix=#{node[:nginx][:basedir]} \
      --with-http_gzip_static_module \
      --with-http_spdy_module --with-http_realip_module \
      --add-module=#{node[:wim][:home]}/ngx_http_redis-#{node[:nginx][:redis][:version]} \
      --add-module=#{node[:wim][:home]}/headers-more-nginx-module-#{node[:nginx][:headers][:version]} \
      --add-module=#{node[:wim][:home]}/nginx_accept_language_module
    make -j3 && make install

    cd ..
    rm -rf headers-more-nginx-module-#{node[:nginx][:headers][:version]}
    rm -rf ngx_http_redis-#{node[:nginx][:redis][:version]}
    rm -rf nginx_accept_language_module
    rm -rf #{nginx_name}
  EOH

  not_if { File.exists?("#{node[:nginx][:basedir]}/sbin/nginx") }
end

directory "#{node[:nginx][:basedir]}/logs" do
  owner node[:wim][:user]
  mode  00750
end

template '/etc/init.d/nginx' do
  source 'nginx.erb'
  owner  'root'
  mode    00755
end

service 'nginx' do
  supports restart: true, stop: true, start: true
  action :enable
end

template "#{node[:nginx][:basedir]}/conf/nginx.conf" do
  source 'nginx.conf.erb'
  owner   node[:wim][:user]
  mode    00644

  notifies :restart, 'service[nginx]', :immediately
end
