git node[:v4l2][:basedir] do
  repository 'git://github.com/umlaeute/v4l2loopback.git'
  revision   'master'
  action     :sync
  user        node[:wim][:user]
  group       node[:wim][:group]
end

cookbook_file "/etc/modules" do
  source 'modules'
end

bash 'install_v4l2' do
  user 'root'
  cwd   node[:v4l2][:basedir]

  code <<-EOH
    make -j3 && make install
    modprobe v4l2loopback
    sleep 1
    chmod 666 /dev/video0
  EOH

  not_if 'test -e /lib/modules/$(uname -r)/extra/v4l2loopback.ko'
end
