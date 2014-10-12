git node[:voice_rails][:basedir] do
  repository "#{node[:git][:gitbase]}/voice-rails.git"
  revision    node[:etc][:default_branch]
  action     :sync
  user        node[:wim][:user]
  group       node[:wim][:group]

  not_if "test -e #{node[:voice_rails][:basedir]}/config"
end

file "#{node[:voice_rails][:basedir]}/.ruby-version" do
  content node[:roles].include?('desktop') ? "ruby-#{node[:mri][:version]}" : "jruby-#{node[:jruby][:version]}"
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

if node[:roles].include?('desktop')
  bash 'install_voice_rails' do
    user  node[:wim][:user]
    group node[:wim][:group]
    cwd   node[:voice_rails][:basedir]

    code <<-EOH
      export HOME=#{node[:wim][:home]}
      export PATH=#{node[:jdk][:home]}/bin:$PATH
      export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8

      source #{node[:rvm][:basedir]}/scripts/rvm
      rvm use ruby-#{node[:mri][:version]}@global
      git reset --hard
      git checkout #{node[:etc][:default_branch]}
      bundle install --path=vendor/bundle --no-binstubs
    EOH

    not_if "test -e #{node[:voice_rails][:basedir]}/vendor/bundle/ruby/#{node[:mri][:baseapi]}/gems"
  end
else
  bash 'install_voice_rails' do
    user  node[:wim][:user]
    group node[:wim][:group]
    cwd   node[:voice_rails][:basedir]

    code <<-EOH
      export HOME=#{node[:wim][:home]}
      export PATH=#{node[:jdk][:home]}/bin:$PATH
  
      source #{node[:rvm][:basedir]}/scripts/rvm
      rvm use jruby-#{node[:jruby][:version]}@global
      git reset --hard
      git checkout #{node[:etc][:default_branch]}
      bundle install --path=vendor/bundle --no-binstubs
      RAILS_ENV=production bundle exec rake assets:precompile 2>/dev/null
    EOH

    not_if "test -e #{node[:voice_rails][:basedir]}/vendor/bundle/jruby/#{node[:jruby][:baseapi]}/gems"
  end
end

bash 'seed_admin_user' do
    user  node[:wim][:user]
    group node[:wim][:group]

    code <<-EOH
      source #{node[:rvm][:basedir]}/scripts/rvm
      cd #{node[:voice_rails][:basedir]}
      bundle exec rake db:migrate
      bundle exec rails runner User.seed_admin_user
    EOH

  not_if {
    `mysql #{node[:mysql][:dbname]} -u#{node[:mysql][:wim_user]} -p#{node[:mysql][:wim_pass]} -e 'SELECT COUNT(*) FROM users INNER JOIN users_roles ON users_roles.user_id = users.id INNER JOIN roles ON roles.id = users_roles.role_id WHERE roles.name = "admin"' | grep '[0-9]'`.to_i > 0
  }
end

directory node[:voice_rails][:logdir] do
  mode 00755
end

directory '/etc/sv/voice-rails' do
  mode 00755
end

template '/etc/sv/voice-rails/run' do
  source 'srv_run.erb'
  mode 00755
end

directory '/etc/sv/voice-rails/log' do
  mode 00755
end

template '/etc/sv/voice-rails/log/run' do
  source 'log_run.erb'
  mode 00755
end

link '/etc/service/voice-rails' do
  to '/etc/sv/voice-rails'
end

directory "#{node[:voice_rails][:basedir]}/public/record" do
  owner  node[:wim][:user]
  group  node[:wim][:group]
  mode   02770
end

cron 'purge_old_mp3_records' do
  minute  '36'
  hour    '3'
  command %Q{find #{node[:voice_rails][:basedir]}/public/record -type f -mtime +30 -exec rm -f {} \\; 2>/dev/null}
end
