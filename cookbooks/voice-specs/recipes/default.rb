git node[:voice_specs][:basedir] do
  repository "#{node[:git][:gitbase]}/voice-specs.git"
  revision    node[:etc][:default_branch]
  action     :sync
  user        node[:wim][:user]
  group       node[:wim][:group]

  not_if "test -e #{node[:voice_specs][:basedir]}"
end
