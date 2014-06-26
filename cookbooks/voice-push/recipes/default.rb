git node[:voice_push][:basedir] do
  repository "git@#{node[:wim][:gitbase]}/voice-push.git"
  revision   'master'
  action     :sync
  user        node[:wim][:user]
  group       node[:wim][:group]

  not_if "test -e #{node[:voice_push][:basedir]}/config"
end

file "#{node[:voice_push][:basedir]}/.ruby-version" do
  content "jruby-#{node[:jruby][:version]}"
  owner   node[:wim][:user]
  group   node[:wim][:group]
  mode    00755
end

template "#{node[:voice_push][:basedir]}/.bundle/config" do
  source   'bundle.config.erb'
  cookbook 'etc'
  owner     node[:wim][:user]
  group     node[:wim][:group]
end

template "#{node[:voice_push][:basedir]}/config/app.yml" do
  source 'app.yml.erb'
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

directory node[:voice_push][:basedir] do
  mode 00755
end

bash 'install_voice_push' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:voice_push][:basedir]

  code <<-EOH
    export HOME=#{node[:wim][:home]}
    export PATH=#{node[:jdk][:home]}/bin:$PATH

    source #{node[:rvm][:basedir]}/scripts/rvm
    rvm use jruby-#{node[:jruby][:version]}@global
    git reset --hard
    git checkout master
    bundle install --path=vendor/bundle
  EOH

  not_if "test -e #{node[:voice_push][:basedir]}/vendor/bundle/jruby/#{node[:jruby][:baseapi]}/gems"
end

directory node[:voice_push][:logdir] do
  mode 00755
end

directory '/etc/sv/voice-push' do
  mode 00755
end

template '/etc/sv/voice-push/run' do
  source 'srv_run.erb'
  mode 00755
end

directory '/etc/sv/voice-push/log' do
  mode 00755
end

template '/etc/sv/voice-push/log/run' do
  source 'log_run.erb'
  mode 00755
end

link '/etc/service/voice-push' do
  to '/etc/sv/voice-push'
end
