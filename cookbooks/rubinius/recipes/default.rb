bash 'install_rbx_ruby' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:wim][:home]

  code <<-EOH
    export HOME=#{node[:wim][:home]}
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    source #{node[:rvm][:basedir]}/scripts/rvm

    rvm install rbx-#{node[:rbx][:version]} && rvm cleanup all 
  EOH

  not_if "#{node[:rvm][:basedir]}/bin/rvm list | grep -q rbx-#{node[:rbx][:version]}"
end

bash 'install_rbx_globals' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:wim][:home]

  code <<-EOH
    export HOME=#{node[:wim][:home]}
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    source #{node[:rvm][:basedir]}/scripts/rvm

    rvm use rbx-#{node[:rbx][:version]}@global && \
    gem install rake bundler hirb wirble ansi git-smart pry redis
  EOH

  not_if "test -e #{node[:rvm][:basedir]}/gems/rbx-#{node[:rbx][:version]}@global/bin/pry"
end
