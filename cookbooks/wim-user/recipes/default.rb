group node[:wim][:group] do
end

user node[:wim][:user] do
  home   node[:wim][:home]
  gid    node[:wim][:group]
  shell '/bin/zsh'
end

group 'sudo' do
  append true
  members node[:wim][:user]

  only_if { node[:roles].include?('desktop') }
end

group 'admin' do
  append true
  members node[:wim][:user]
end

bash 'create_wim_home' do
  user 'root'

  code <<-EOH
    cp -r /etc/skel #{node[:wim][:home]}
    chown -R #{node[:wim][:user]}.#{node[:wim][:group]} #{node[:wim][:home]}
  EOH

  not_if "test -e #{node[:wim][:home]}"
end

directory node[:wim][:home] do
  mode 00700
end

directory "#{node[:wim][:home]}/bin" do
  owner node[:wim][:user]
  group node[:wim][:group]
  mode 00700
end

template "#{node[:wim][:home]}/.bash_aliases" do
  source  "bash_aliases.erb"
  mode    00755
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

directory '/opt' do
  mode  00755
  owner node[:wim][:user]
  group node[:wim][:group]
end

directory node[:wim][:logdir] do
  mode  00750
  owner node[:wim][:user]
  group node[:wim][:group]
end

bash 'install_ohmyzsh' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:wim][:home]

  code <<-EOH
    export HOME=#{node[:wim][:home]}
    git clone git://github.com/robbyrussell/oh-my-zsh.git #{node[:wim][:home]}/.oh-my-zsh
  EOH

  not_if "test -e #{node[:wim][:home]}/.oh-my-zsh/oh-my-zsh.sh"
end

template "#{node[:wim][:home]}/.oh-my-zsh/custom/fwoeck.zsh-theme" do
  source 'fwoeck.zsh-theme.erb'
  mode    00644
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

template "#{node[:wim][:home]}/.zshrc" do
  source 'zshrc.erb'
  mode    00755
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

directory "#{node[:wim][:home]}/.oh-my-zsh/completions" do
  owner node[:wim][:user]
  group node[:wim][:group]
end

cookbook_file "#{node[:wim][:home]}/.oh-my-zsh/completions/_sv" do
  source 'compdef_sv'
  mode    00644
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

file "#{node[:wim][:home]}/.curlrc" do
  content "insecure\n"
  mode    00644
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

directory "#{node[:wim][:home]}/.ssh" do
  mode  00700
  owner node[:wim][:user]
  group node[:wim][:group]
end

template "#{node[:wim][:home]}/.ssh/config" do
  source 'ssh_config.erb'
  mode    00644
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

template "#{node[:wim][:home]}/.gitconfig" do
  source 'gitconfig.erb'
  mode    00644
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

cookbook_file "#{node[:wim][:home]}/.ctags" do
  source 'ctags'
  mode    00644
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

cookbook_file "#{node[:wim][:home]}/.ssh/authorized_keys" do
  owner node[:wim][:user]
  group node[:wim][:group]
  mode  00600
end

cookbook_file "#{node[:wim][:home]}/.ssh/id_rsa" do
  owner node[:wim][:user]
  group node[:wim][:group]
  mode  00400

  not_if { node[:roles].include?('desktop') }
end

cookbook_file "#{node[:wim][:home]}/.ssh/id_rsa.pub" do
  owner node[:wim][:user]
  group node[:wim][:group]
  mode  00644

  not_if { node[:roles].include?('desktop') }
end
