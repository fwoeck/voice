git node[:voice_specs][:basedir] do
  repository "#{node[:git][:gitbase]}/voice-specs.git"
  revision    node[:etc][:default_branch]
  action     :sync
  user        node[:wim][:user]
  group       node[:wim][:group]

  not_if "test -e #{node[:voice_specs][:basedir]}"
end

template "#{node[:voice_specs][:basedir]}/config/app.yml" do
  source 'app.yml.erb'
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

template "#{node[:voice_specs][:basedir]}/config/load.yml.example" do
  source 'load.yml.erb'
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

template "#{node[:voice_specs][:basedir]}/config/mongoid.yml" do
  source 'mongoid.yml.erb'
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

file "#{node[:voice_specs][:basedir]}/.ruby-version" do
  content "ruby-#{node[:mri][:version]}"
  owner   node[:wim][:user]
  group   node[:wim][:group]
  mode    00755
end

template "#{node[:voice_specs][:basedir]}/.bundle/config" do
  source   'bundle.config.erb'
  cookbook 'etc'
  owner     node[:wim][:user]
  group     node[:wim][:group]
end

bash 'install_voice_specs' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:voice_specs][:basedir]

  code <<-EOH
    export HOME=#{node[:wim][:home]}
    export PATH=#{node[:jdk][:home]}/bin:$PATH
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8

    source #{node[:rvm][:basedir]}/scripts/rvm
    rvm use ruby-#{node[:mri][:version]}@global
    git reset --hard
    git checkout #{node[:etc][:default_branch]}
    git submodule init
    git submodule update
    bundle install --path=vendor/bundle --no-binstubs
  EOH

  not_if "test -e #{node[:voice_specs][:basedir]}/vendor/bundle/ruby/#{node[:mri][:baseapi]}/gems"
end
