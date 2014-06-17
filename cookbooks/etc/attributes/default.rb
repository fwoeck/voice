default[:ahn][:ami_pass]                 = '***REMOVED***'
default[:ahn][:ami_user]                 = 'ahn_ami'
default[:ahn][:ami_host]                 = '127.0.0.1'

default[:aws][:cdn]                      = 'http://dokmatic-cdn.s3.amazonaws.com/chef'

default[:asterisk][:version]             = '11.10.2'
default[:asterisk][:g729_checksum]       = '8bbd222c2b1f7883d16387809ad7bfdc85f8e32a7fb5b73e499b1740a93664b1'

default[:etc][:domain]                   = 'wimdu.com'
default[:etc][:domain_hostname]          = 'wim01.wimdu.com' # This is the main deployment target
default[:etc][:domain_host]              =  false # Set this to true in /etc/chef/client.json, if we are wim01
default[:etc][:ext_interface]            = 'eth0'
default[:etc][:ip_blacklist]             = [ # Last update 2014-06-15
                                             '23.250.10.130',   # !
                                             '37.8.0.0/16',     # !
                                             '37.44.0.0/16',    # !
                                             '37.59.0.0/16',    # !
                                             '37.75.0.0/16',    # !
                                             '37.187.0.0/16',   # !
                                             '64.23.56.18'
                                           ]
default[:etc][:external_ip]              = ''            # Set this in the Vagrantfile or /etc/chef/client.json
default[:etc][:internal_ip]              = '127.0.1.1'   # Caution: changing this will break things
default[:etc][:railsenv]                 = 'production'
default[:etc][:skel_sum]                 = '7230bf9bbb54a032a4cc4d33535d0ff0885b4929f6c221912dc2ef7d6713b982'
default[:etc][:path]                     = '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'

default[:flashphoner][:basename]         = 'FlashphonerWebCallServer'
default[:flashphoner][:version]          = '3.0.745'
default[:flashphoner][:ws_port]          = '8080'

default[:git][:user][:name]              = 'Frank Woeckener'
default[:git][:user][:email]             = 'fwoeck@gmail.com'
default[:git][:github][:user]            = 'fwoeck'
default[:git][:github][:token]           = 'replaceme'

default[:jdk][:home]                     = '/opt/jdk'
default[:jdk][:version]                  = '1.8.0_05'
default[:jdk][:opts]                     = '-server -Djava.awt.headless=true -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly'

default[:jruby][:baseapi]                = '1.9'
default[:jruby][:version]                = '1.7.12'
default[:jruby][:opts]                   = '-J-XX:+UseCodeCacheFlushing -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 -J-noverify'

default[:mongodb][:db][:development]     = 'wimdu_development'
default[:mongodb][:db][:production]      = 'wimdu_production'
default[:mongodb][:db][:test]            = 'wimdu_test'
default[:mongodb][:host]                 = '127.0.0.1'
default[:mongodb][:port]                 =  27017
default[:mongoid][:basedir]              = '/opt/mongoid'

default[:mri][:baseapi]                  = '2.1'
default[:mri][:version]                  = '2.1.2'

default[:mysql][:wim_pass]               = '***REMOVED***'
default[:mysql][:wim_user]               = 'astrealtime'
default[:mysql][:dbname]                 = 'asterisk'
default[:mysql][:host]                   = '127.0.0.1'
default[:mysql][:port]                   =  3306
default[:mysql][:root_pass]              = '***REMOVED***'
default[:mysql][:socket]                 = '/var/run/mysqld/mysqld.sock'

default[:nginx][:basedir]                = '/opt/nginx'
default[:nginx][:fe_port]                =  80
default[:nginx][:version]                = '1.6.0'
default[:nginx][:language][:checksum]    = '4609c52787e10a86d0bf25b524b91eaa3e8bb80d4208eaa2de8a9db14002f551'
default[:nginx][:headers][:version]      = '0.25'
default[:nginx][:redis][:version]        = '0.3.7'

default[:passenger][:version]            = '4.0.45'
default[:postfix][:remote_admin]         = 'frank.woeckener@wimdu.com'

default[:rabbitmq][:host]                = '127.0.0.1'
default[:rabbitmq][:pass]                = '***REMOVED***'
default[:rabbitmq][:user]                = 'wim'

default[:rbx][:baseapi]                  = '2.1'
default[:rbx][:version]                  = '2.2.9'

default[:redis][:host]                   = '127.0.0.1'
default[:redis][:port]                   =  6379
default[:redis][:db][:fe_wim]            =  1

default[:rvm][:basedir]                  = '/home/wim/.rvm'

default[:sipgate][:pass]                 = 'replaceme'
default[:sipgate][:proxy]                = 'sipconnect.sipgate.de'
default[:sipgate][:trunk]                = 'replaceme'
default[:sipgate][:number]               = 'replaceme'

default[:sipgate][:sms][:apihost]        = 'api.sipgate.net'
default[:sipgate][:sms][:password]       = 'replaceme'
default[:sipgate][:sms][:user]           = 'replaceme'

default[:skype][:pass]                   = 'replaceme'
default[:skype][:proxy]                  = 'sip.skype.com'
default[:skype][:trunk]                  = 'replaceme'

default[:smtp][:address]                 = 'email-smtp.eu-west-1.amazonaws.com'
default[:smtp][:port]                    =  25
default[:smtp][:username]                = 'replaceme'
default[:smtp][:password]                = 'replaceme'

default[:tmux][:version]                 = '1.9a'

default[:vagrant][:gateway]              = '33.33.33.1'
default[:vagrant][:local_net]            = '192.168.10.0'
default[:vagrant][:local_mask]           = '255.255.255.0'

default[:vnc][:password]                 = '***REMOVED***'
default[:vnc][:display]                  =  0

default[:v4l2][:basedir]                 = '/opt/v4l2'

default[:wim][:gitbase]                  = 'dkm01.dokmatic.com' # This is the gitolite repo-host
default[:wim][:user]                     = 'wim'
default[:wim][:group]                    = 'wim'
default[:wim][:home]                     = '/home/wim'
default[:wim][:logdir]                   = '/opt/log'
default[:wim][:domain_user]              = 'wim'         # Caution: this must match the wim-user that
                                                         #          is configured at the base host wim01
default[:wim][:rails][:basedir]          = '/opt/voice-rails'
default[:wim][:zshplugs]                 = 'last-working-dir'
default[:wim][:color]                    = 'red'
