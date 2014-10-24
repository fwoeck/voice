cookbook_file Chef::Config['file_cache_path'] + "/vim.makefile" do
  owner  'root'
  source 'Makefile'

  not_if { File.exists?('/usr/local/bin/vim') }
end

tar_name = "vim-#{node[:vim][:version]}"

remote_file "#{Chef::Config['file_cache_path']}/#{tar_name}.tgz" do
  source "#{node[:aws][:cdn]}/#{tar_name}.tgz"
  notifies :run, 'bash[install_vim]', :immediately
end

directory "#{node[:wim][:home]}/.vim" do
  owner node[:wim][:user]
  group node[:wim][:group]
  mode  00755
end

directory "#{node[:wim][:home]}/.vim/colors" do
  owner node[:wim][:user]
  group node[:wim][:group]
  mode  00755
end

cookbook_file "#{node[:wim][:home]}/.vim/colors/ir_black.vim" do
  owner   node[:wim][:user]
  group   node[:wim][:group]
  source 'ir_black.vim'
  mode    00755
end

bash 'install_vim' do
  user 'root'
  cwd   Chef::Config['file_cache_path']

  code <<-EOH
    tar -zxf #{tar_name}.tgz
    cp -f vim.makefile #{tar_name}/src/Makefile
    cd #{tar_name}/src
    make -j3
    make install
    cd ../..
    rm -rf #{tar_name}
  EOH

  not_if { File.exists?('/usr/local/bin/vim') }
end

bash 'install_vundle' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:wim][:home]

  code <<-EOH
    export HOME=#{node[:wim][:home]}
    git clone https://github.com/gmarik/vundle.git #{node[:wim][:home]}/.vim/bundle/vundle
  EOH

  not_if { File.exists?("#{node[:wim][:home]}/.vim/bundle/vundle") }
end

cookbook_file "#{node[:wim][:home]}/.vimrc" do
  owner   node[:wim][:user]
  group   node[:wim][:group]
  source 'vimrc'
  mode    00755

  notifies :run, 'bash[update_vundle]', :immediately
# not_if { File.exists?("#{node[:wim][:home]}/.vimrc") }
end

bash 'update_vundle' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:wim][:home]

  code <<-EOH
    export HOME=#{node[:wim][:home]}
    /usr/local/bin/vim +BundleInstall +qall
  EOH

  action :nothing
end
