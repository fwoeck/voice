file "#{node[:wim][:home]}/.bash_profile" do
  content "[[ -s '#{node[:rvm][:basedir]}/scripts/rvm' ]] && source '#{node[:rvm][:basedir]}/scripts/rvm'"
  mode    00755
  owner   node[:wim][:user]
  group   node[:wim][:group]
end

file "#{node[:wim][:home]}/.zlogin" do
  content "[[ -s '#{node[:rvm][:basedir]}/scripts/rvm' ]] && source '#{node[:rvm][:basedir]}/scripts/rvm'"
  owner   node[:wim][:user]
  group   node[:wim][:group]
  mode    00755
end

# This is necessary globally so invocations by root will succeed:
template "/etc/rvmrc" do
  owner   node[:wim][:user]
  group   node[:wim][:group]
  mode    00755
  source 'rvmrc.erb'
end

cookbook_file "#{node[:wim][:home]}/.irbrc" do
  owner   node[:wim][:user]
  group   node[:wim][:group]
  mode    00755
  source 'irbrc'
end

cookbook_file "#{node[:wim][:home]}/.gemrc" do
  owner   node[:wim][:user]
  group   node[:wim][:group]
  mode    00755
  source 'gemrc'
end

bash 'install_rvm' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:wim][:home]

  code <<-EOH
    export HOME=#{node[:wim][:home]}
    curl -sSL https://get.rvm.io | bash -s master; echo

    source #{node[:rvm][:basedir]}/scripts/rvm
    rvm rvmrc warning ignore all.rvmrcs
  EOH

  not_if "test -e #{node[:rvm][:basedir]}/bin/rvm"
end
