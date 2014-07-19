package 'libpcap-dev'

tar_name = "sipp-#{node[:sipp][:version]}"

remote_file "#{Chef::Config['file_cache_path']}/#{tar_name}.tar.gz" do
  source "#{node[:aws][:cdn]}/#{tar_name}.tar.gz"
  notifies :run, 'bash[install_sipp]', :immediately
end

bash 'install_sipp' do
  user 'root'
  cwd   Chef::Config['file_cache_path']

  code <<-EOH
    tar -zxf #{tar_name}.tar.gz
    cd #{tar_name}
    ./configure --with-pcap && make -j3 && make install
    cd ..
    rm -rf #{tar_name}
  EOH

  action :nothing
end
