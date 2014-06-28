git node[:voice_docs][:basedir] do
  repository "git@#{node[:wim][:gitbase]}/voice-docs.git"
  revision   'master'
  action     :sync
  user        node[:wim][:user]
  group       node[:wim][:group]

  not_if "test -e #{node[:voice_docs][:basedir]}"
end
