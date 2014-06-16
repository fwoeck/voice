bash 'install_mri_ruby' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:wim][:home]

  code <<-EOH
    export HOME=#{node[:wim][:home]}
    source #{node[:rvm][:basedir]}/scripts/rvm

    rvm install ruby-#{node[:mri][:version]} && \
      rvm use ruby-#{node[:mri][:version]}@global --default && \
      rvm cleanup all 
  EOH

  not_if "#{node[:rvm][:basedir]}/bin/rvm list | grep -q ruby-#{node[:mri][:version]}"
end

bash 'install_mri_globals' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:wim][:home]

  code <<-EOH
    export HOME=#{node[:wim][:home]}
    source #{node[:rvm][:basedir]}/scripts/rvm

    rvm use ruby-#{node[:mri][:version]}@global && \
    gem install rake bundler hirb wirble ansi git-smart pry redis byebug
  EOH

  not_if "test -e #{node[:rvm][:basedir]}/gems/ruby-#{node[:mri][:version]}@global/bin/pry"
end
