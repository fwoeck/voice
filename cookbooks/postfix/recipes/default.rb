package 'postfix-pcre'

service 'postfix' do
  supports restart: true, stop: true, start: true
  action   [:enable, :start]
end

cookbook_file '/etc/postfix/cacert.pem' do
  source 'cacert.pem'
  owner  'postfix'
  mode    00640

  notifies :restart, 'service[postfix]', :delayed
  not_if { File.exists?('/etc/postfix/cacert.pem') }
end

template '/etc/aliases' do
  source 'aliases.erb'
  mode    00644

  notifies :run, 'bash[compile_postfix_configuration]', :immediately
end

template '/etc/postfix/generic' do
  source 'generic.erb'
  mode    00644

  notifies :run, 'bash[compile_postfix_configuration]', :immediately
end

template '/etc/mailname' do
  source 'mailname.erb'
  mode    00644

  notifies :restart, 'service[postfix]', :delayed
end

template '/etc/postfix/main.cf' do
  source 'main.cf.erb'
  mode    00644

  notifies :restart, 'service[postfix]', :delayed
end

template '/etc/postfix/sasl_passwd' do
  source 'sasl_passwd.erb'
  mode    00400

  notifies :run, 'bash[compile_postfix_configuration]', :immediately
end

template '/etc/postfix/sender_canonical' do
  source 'sender_canonical.erb'
  mode    00644

  notifies :run, 'bash[compile_postfix_configuration]', :immediately
end

template '/etc/postfix/mydestinations' do
  source 'destinations.erb'
  mode    00644

  notifies :run, 'bash[compile_postfix_configuration]', :immediately
end

bash 'compile_postfix_configuration' do
  user 'root'

  code <<-EOH
    cd /etc/postfix
    newaliases

    test -e sender_canonical && postmap hash:sender_canonical
    test -e sasl_passwd && postmap hash:sasl_passwd
    test -e generic && postmap hash:generic
    true
  EOH

  action :nothing
  notifies :restart, 'service[postfix]', :delayed
end
