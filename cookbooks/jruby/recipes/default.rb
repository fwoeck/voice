cookbook_file "#{node[:wim][:home]}/.jrubyrc" do
  source "jrubyrc"
  owner   node[:wim][:user]
  group   node[:wim][:group]
  mode    00755
end

directory "#{node[:rvm][:basedir]}/repos" do
  owner node[:wim][:user]
  group node[:wim][:group]
  mode  00755
end

bash 'install_jruby' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:wim][:home]

  code <<-EOH
    export HOME=#{node[:wim][:home]}
    export JDK_HOME=#{node[:jdk][:home]}
    export JAVA_HOME=#{node[:jdk][:home]}
    export PATH=#{node[:jdk][:home]}/bin:$PATH

    source #{node[:rvm][:basedir]}/scripts/rvm
    rvm install jruby-#{node[:jruby][:version]} && rvm cleanup all
  EOH

  not_if "#{node[:rvm][:basedir]}/bin/rvm list | grep -q jruby-#{node[:jruby][:version]}"
end

bash 'fix_ffi_lib_version' do
  user  node[:wim][:user]
  group node[:wim][:group]

  code <<-EOH
    cd #{node[:rvm][:basedir]}/rubies/jruby-#{node[:jruby][:version]}/lib/jni
    mv i386-Linux i386-Linux.org
    ln -s x86_64-Linux i386-Linux
  EOH

  base = "#{node[:rvm][:basedir]}/rubies/jruby-#{node[:jruby][:version]}/lib/jni"
  diff = "diff #{base}/i386-Linux/libjffi*.so #{base}/x86_64-Linux/libjffi*.so >/dev/null"
  only_if { !system(diff) }
end

bash 'install_jrb_gems' do
  user  node[:wim][:user]
  group node[:wim][:group]
  cwd   node[:wim][:home]

  code <<-EOH
    export HOME=#{node[:wim][:home]}
    export JDK_HOME=#{node[:jdk][:home]}
    export JAVA_HOME=#{node[:jdk][:home]}
    export PATH=#{node[:jdk][:home]}/bin:$PATH

    source #{node[:rvm][:basedir]}/scripts/rvm
    rvm use jruby-#{node[:jruby][:version]}@global && \
      gem install bundler jruby-openssl hirb wirble git-smart pry rake
  EOH

  not_if "test -e #{node[:rvm][:basedir]}/gems/jruby-#{node[:jruby][:version]}@global/bin/pry"
end
