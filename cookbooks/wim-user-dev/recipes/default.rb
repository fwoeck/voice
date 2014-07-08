package 'nfs-kernel-server'
package 'nfs-common'

file '/opt/.metadata_never_index' do
  content ''
  owner 'root'
end

file '/etc/exports' do
  content "/opt #{node[:vagrant][:gateway]}(rw,async,insecure,no_subtree_check,all_squash,anonuid=1000,anongid=1000)\n"
  notifies :run, 'bash[exportfs]', :immediately
end

bash 'exportfs' do
  user 'root'

  code <<-EOH
    exportfs -ra
  EOH

  action :nothing
end
