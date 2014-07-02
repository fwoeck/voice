tar_name = "phantomjs-#{node[:phantomjs][:version]}-linux-x86_64"

remote_file "#{Chef::Config['file_cache_path']}/#{tar_name}.tar.bz2" do
  source "#{node[:aws][:cdn]}/#{tar_name}.tar.bz2"
  owner   node[:dkm][:user]

  notifies :run, 'bash[install_phantomjs]', :immediately
end

bash 'install_phantomjs' do
  user  'root'

  code <<-EOH
    cd #{Chef::Config['file_cache_path']}
    tar xjf #{tar_name}.tar.bz2

    rm -f #{node[:phantomjs][:basedir]}/phantomjs 2>/dev/null
    mv #{tar_name}/bin/phantomjs #{node[:phantomjs][:basedir]}/

    rm -rf #{tar_name}
    chmod a+x #{node[:phantomjs][:basedir]}/phantomjs
  EOH

  action :nothing
end
