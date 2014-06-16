execute 'add-nodejs-repo' do
  command 'add-apt-repository ppa:chris-lea/node.js'
  not_if { File.exists?('/usr/bin/nodejs') }
end

execute 'update-apt-nodejs' do
  command 'apt-get update'
  not_if { File.exists?('/usr/bin/nodejs') }
end

package 'nodejs'

execute 'install-coffee-script' do
  command 'npm -g install coffee-script'
  not_if { File.exists?('/usr/bin/coffee') }
end

execute 'install-coffeelint' do
  command 'npm -g install coffeelint'
  not_if { File.exists?('/usr/bin/coffeelint') }
end
