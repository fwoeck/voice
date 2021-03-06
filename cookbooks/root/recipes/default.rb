remote_directory '/root/bin' do
  files_mode 00755
end

file '/root/.curlrc' do
  content "insecure\n"
  mode    00644
end

cookbook_file '/root/.bash_aliases' do
  source 'bash_aliases'
  mode    00644
end

cookbook_file '/root/.vimrc' do
  source 'vimrc'
  mode    00644
end

cookbook_file '/root/.gemrc' do
  source 'gemrc'
  mode    00644
end

directory '/root/.ssh' do
  owner 'root'
  group 'root'
  mode   00700
end

directory '/etc/chef' do
  owner 'root'
  group 'root'
  mode   00700
end
