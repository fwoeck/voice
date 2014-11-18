tar_name = "chromedriver-#{node[:chromedriver][:version]}-linux-x86_64"

remote_file "#{Chef::Config['file_cache_path']}/#{tar_name}.tgz" do
  source "#{node[:aws][:cdn]}/#{tar_name}.tgz"
  owner   node[:wim][:user]

  notifies :run, 'bash[install_chromedriver]', :immediately
end

bash 'install_chromedriver' do
  user  'root'

  code <<-EOH
    cd #{Chef::Config['file_cache_path']}
    tar xzf #{tar_name}.tgz

    rm -f #{node[:chromedriver][:basedir]}/chromedriver 2>/dev/null
    mv chromedriver #{node[:chromedriver][:basedir]}/

    chown 0:0 #{node[:chromedriver][:basedir]}/chromedriver
    chmod a+x #{node[:chromedriver][:basedir]}/chromedriver
  EOH

  action :nothing
end
