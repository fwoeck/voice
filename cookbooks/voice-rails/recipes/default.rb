git node[:voice_rails][:basedir] do
  repository "git@#{node[:wim][:gitbase]}/voice-rails.git"
  revision   'master'
  action     :sync
  user        node[:wim][:user]
  group       node[:wim][:group]

  not_if "test -e #{node[:voice_rails][:basedir]}/config"
end

file "#{node[:voice_rails][:basedir]}/.ruby-version" do
  content "ruby-#{node[:mri][:version]}"
  owner   node[:wim][:user]
  group   node[:wim][:group]
  mode    00755
end

template "#{node[:voice_rails][:basedir]}/.bundle/config" do
  source   'bundle.config.erb'
  cookbook 'etc'
  owner     node[:wim][:user]
  group     node[:wim][:group]
end

template "#{node[:voice_rails][:basedir]}/config/app.yml" do
  source 'app.yml.erb'
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

template "#{node[:voice_rails][:basedir]}/config/mongoid.yml" do
  source 'mongoid.yml.erb'
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

template "#{node[:voice_rails][:basedir]}/config/database.yml" do
  source 'database.yml.erb'
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

directory node[:voice_rails][:basedir] do
  mode 00755
end

bash 'install_voice_rails' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:voice_rails][:basedir]

  code <<-EOH
    export HOME=#{node[:wim][:home]}
    export PATH=#{node[:jdk][:home]}/bin:$PATH

    source #{node[:rvm][:basedir]}/scripts/rvm
    rvm use ruby-#{node[:mri][:version]}@global
    git reset --hard
    git checkout master
    bundle install --path=vendor/bundle
  EOH

  not_if "test -e #{node[:voice_rails][:basedir]}/vendor/bundle/ruby/#{node[:mri][:baseapi]}/gems"
end

directory node[:voice_rails][:logdir] do
  mode 00755
end

directory '/srv/voice-rails' do
  mode 00755
end

template '/srv/voice-rails/run' do
  source 'srv_run.erb'
  mode 00755
end

directory '/srv/voice-rails/log' do
  mode 00755
end

template '/srv/voice-rails/log/run' do
  source 'log_run.erb'
  mode 00755
end

# link '/etc/service/voice-rails' do
#   to '/srv/voice-rails'
# end
