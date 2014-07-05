git node[:voice_ahn][:basedir] do
  repository "git@#{node[:wim][:gitbase]}/voice-ahn.git"
  revision    node[:etc][:default_branch]
  action     :sync
  user        node[:wim][:user]
  group       node[:wim][:group]

  not_if "test -e #{node[:voice_ahn][:basedir]}/config"
end

file "#{node[:voice_ahn][:basedir]}/.ruby-version" do
  content node[:roles].include?('desktop') ? "ruby-#{node[:mri][:version]}" : "jruby-#{node[:jruby][:version]}"
  owner   node[:wim][:user]
  group   node[:wim][:group]
  mode    00755
end

template "#{node[:voice_ahn][:basedir]}/.bundle/config" do
  source   'bundle.config.erb'
  cookbook 'etc'
  owner     node[:wim][:user]
  group     node[:wim][:group]
end

template "#{node[:voice_ahn][:basedir]}/config/app.yml" do
  source 'app.yml.erb'
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

directory node[:voice_ahn][:basedir] do
  mode 00755
end

if node[:roles].include?('desktop')
  bash 'install_voice_ahn' do
    user  node[:wim][:user]
    group node[:wim][:group]
    cwd   node[:voice_ahn][:basedir]

    code <<-EOH
      export HOME=#{node[:wim][:home]}
      export PATH=#{node[:jdk][:home]}/bin:$PATH
      export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8

      source #{node[:rvm][:basedir]}/scripts/rvm
      rvm use ruby-#{node[:mri][:version]}@global
      git reset --hard
      git checkout #{node[:etc][:default_branch]}
      bundle install --path=vendor/bundle
    EOH

    not_if "test -e #{node[:voice_ahn][:basedir]}/vendor/bundle/ruby/#{node[:mri][:baseapi]}/gems"
  end
else
  bash 'install_voice_ahn' do
    user  node[:wim][:user]
    group node[:wim][:group]
    cwd   node[:voice_ahn][:basedir]

    code <<-EOH
      export HOME=#{node[:wim][:home]}
      export PATH=#{node[:jdk][:home]}/bin:$PATH
  
      source #{node[:rvm][:basedir]}/scripts/rvm
      rvm use jruby-#{node[:jruby][:version]}@global
      git reset --hard
      git checkout #{node[:etc][:default_branch]}
      bundle install --path=vendor/bundle
    EOH

    not_if "test -e #{node[:voice_ahn][:basedir]}/vendor/bundle/jruby/#{node[:jruby][:baseapi]}/gems"
  end
end

directory node[:voice_ahn][:logdir] do
  mode 00755
end

directory '/etc/sv/voice-ahn' do
  mode 00755
end

template '/etc/sv/voice-ahn/run' do
  source 'srv_run.erb'
  mode 00755
end

directory '/etc/sv/voice-ahn/log' do
  mode 00755
end

template '/etc/sv/voice-ahn/log/run' do
  source 'log_run.erb'
  mode 00755
end

link '/etc/service/voice-ahn' do
  to '/etc/sv/voice-ahn'
end
