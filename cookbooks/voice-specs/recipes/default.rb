git node[:voice_specs][:basedir] do
  repository "#{node[:git][:gitbase]}/voice-specs.git"
  revision    node[:etc][:default_branch]
  action     :sync
  user        node[:wim][:user]
  group       node[:wim][:group]

  not_if "test -e #{node[:voice_specs][:basedir]}"
end

template "#{node[:voice_specs][:basedir]}/config/app.yml.example" do
  source 'app.yml.erb'
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
