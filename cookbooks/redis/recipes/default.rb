package 'redis-server'

service 'redis-server' do
  supports restart: true, stop: true, start: true
  action   [:enable, :start]
end

template '/etc/redis/redis.conf' do
  source 'redis.conf.erb'
  mode 00644

  notifies :restart, 'service[redis-server]', :immediately
end
