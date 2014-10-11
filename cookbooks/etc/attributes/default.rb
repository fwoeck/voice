default[:ahn][:ami_user]                 = 'ahn_ami'
default[:ahn][:ami_host]                 = '127.0.0.1'

default[:aws][:cdn]                      = 'http://dokmatic-cdn.s3.amazonaws.com/wimdu'

default[:asterisk][:version]             = '11.13.0'
default[:asterisk][:g729_checksum]       = '8bbd222c2b1f7883d16387809ad7bfdc85f8e32a7fb5b73e499b1740a93664b1'
default[:asterisk][:stun_server]         = 'stun.l.google.com:19302'
default[:asterisk][:rtp_start]           =  10000
default[:asterisk][:rtp_end]             =  20000
default[:asterisk][:wss_port]            =  8009
default[:asterisk][:ws_port]             =  8008

default[:etc][:internal_ip]              = '127.0.1.1'   # Caution: changing this will break things
default[:etc][:railsenv]                 = 'production'
default[:etc][:default_branch]           = 'master'
default[:etc][:skel_sum]                 = '7230bf9bbb54a032a4cc4d33535d0ff0885b4929f6c221912dc2ef7d6713b982'
default[:etc][:path]                     = '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'
default[:etc][:logdir]                   = '/opt/log'

default[:elasticsearch][:basedir]        = '/opt/elasticsearch'
default[:elasticsearch][:version]        = '1.3.2'

default[:flashphoner][:host]             = '127.0.0.1'
default[:flashphoner][:basename]         = 'FlashphonerWebCallServer'
default[:flashphoner][:version]          = '3.0.885'
default[:flashphoner][:ws_port]          = '8080'

default[:jdk][:home]                     = '/opt/jdk'
default[:jdk][:version]                  = '1.8.0_20'
default[:jdk][:opts]                     = '-Xmn512m -Xms2048m -Xmx2048m -server -Djava.awt.headless=true -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly'

default[:jruby][:baseapi]                = '1.9'
default[:jruby][:version]                = '1.7.16'
default[:jruby][:opts]                   = '-J-XX:+UseCodeCacheFlushing -J-Djruby.thread.pooling=true -J-Djruby.cext.enabled=false -J-Djruby.compat.version=1.9 -J-Dfile.encoding=UTF-8 -J-Djruby.jit.threshold=5 -J-Djruby.compile.mode=JIT -J-server'

default[:mongodb][:db][:development]     = 'voice_development'
default[:mongodb][:db][:production]      = 'voice_production'
default[:mongodb][:db][:test]            = 'voice_test'
default[:mongodb][:host]                 = '127.0.0.1'
default[:mongodb][:port]                 =  27017

default[:mri][:baseapi]                  = '2.1.0'
default[:mri][:version]                  = '2.1.3'

default[:mysql][:wim_user]               = 'astrealtime'
default[:mysql][:dbname]                 = 'asterisk'
default[:mysql][:host]                   = '127.0.0.1'
default[:mysql][:port]                   =  3306
default[:mysql][:socket]                 = '/var/run/mysqld/mysqld.sock'

default[:nginx][:basedir]                = '/opt/nginx'
default[:nginx][:fe_port]                =  443
default[:nginx][:version]                = '1.7.5'
default[:nginx][:language][:checksum]    = '4609c52787e10a86d0bf25b524b91eaa3e8bb80d4208eaa2de8a9db14002f551'
default[:nginx][:headers][:version]      = '0.25'
default[:nginx][:redis][:version]        = '0.3.7'

default[:opus][:version]                 = '1.1'

default[:phantomjs][:version]            = '1.9.8'
default[:phantomjs][:basedir]            = '/usr/local/bin'

default[:puma][:host]                    = '127.0.0.1'
default[:puma][:port]                    =  9292
default[:puma_test][:port]               =  8089
default[:capybara][:port]                =  8088

default[:rabbitmq][:host]                = '127.0.0.1'
default[:rabbitmq][:user]                = 'wim'

default[:redis][:host]                   = '127.0.0.1'
default[:redis][:port]                   =  6379
default[:redis][:db][:nginx]             =  2
default[:redis][:db][:rails]             =  3
default[:redis][:db][:numbers]           =  default[:redis][:db][:rails]
default[:redis][:db][:custom]            =  default[:redis][:db][:rails]
default[:redis][:db][:push]              =  default[:redis][:db][:rails]
default[:redis][:db][:ahn]               =  default[:redis][:db][:rails]

default[:rvm][:basedir]                  = '/home/wim/.rvm'

default[:sipp][:version]                 = '3.4.1'

default[:tmux][:version]                 = '1.9a'
default[:vim][:version]                  = '7-4-465'

default[:vnc][:display]                  =  0
default[:vnc][:version]                  = '1.3.1'
default[:vnc][:basedir]                  = '/opt/tigervnc'

default[:voice_specs][:basedir]          = '/opt/voice-specs'

default[:voice_ahn][:basedir]            = '/opt/voice-ahn'
default[:voice_ahn][:logdir]             =  default[:etc][:logdir] + '/voice-ahn'
default[:voice_ahn][:record]             = '/var/punchblock'

default[:voice_custom][:basedir]         = '/opt/voice-custom'
default[:voice_custom][:logdir]          =  default[:etc][:logdir] + '/voice-custom'
default[:voice_custom][:gracetime]       =  90

default[:voice_push][:basedir]           = '/opt/voice-push'
default[:voice_push][:logdir]            =  default[:etc][:logdir] + '/voice-push'
default[:voice_push][:host]              = '127.0.0.1'
default[:voice_push][:port]              =  8889

default[:voice_rails][:basedir]          = '/opt/voice-rails'
default[:voice_rails][:logdir]           =  default[:etc][:logdir] + '/voice-rails'

default[:voice_numbers][:basedir]        = '/opt/voice-numbers'
default[:voice_numbers][:logdir]         =  default[:etc][:logdir] + '/voice-numbers'
default[:voice_numbers][:stats_url]      = '/data/queue-stats.svg'
default[:voice_numbers][:stats_img]      =  default[:voice_rails][:basedir] + '/public' + default[:voice_numbers][:stats_url]
default[:voice_numbers][:stats_rrd]      =  default[:voice_numbers][:basedir] + '/data/queue_stats.rrd'

default[:v4l2][:basedir]                 = '/opt/v4l2'

default[:wim][:gitbase]                  = 'git://github.com/fwoeck'
default[:wim][:user]                     = 'wim'
default[:wim][:group]                    = 'wim'
default[:wim][:home]                     = '/home/wim'
default[:wim][:domain_user]              = 'wim'
default[:wim][:rails][:basedir]          = '/opt/voice-rails'
default[:wim][:zshplugs]                 = 'last-working-dir'
default[:wim][:color]                    = 'red'


# -> For the time being, singular keys (e.g. availability)
#    MUST end with a "y", whereas plural keys (e.g. skills)
#    must NOT.
#
# -> We need "admin" and "agent" to be among the roles.
#    Admins have special rights, agents receive calls.
#
default[:agent][:attributes] = <<-EOF
languages:
  de:          "Ich spreche deutsch"
  fr:          "Je parle français"
  en:          "I speak english"
  it:          "Parlo italiano"
  es:          "Hablo español"

ui_locales:
  -            "en"
  -            "de"

roles:
  agent:       "Agent"
  trainer:     "Trainer"
  supervisor:  "Supervisor"
  admin:       "Administrator"

skills:
  new_booking:
    en:        "New booking"
    de:        "Neue Buchung"
  ext_booking:
    en:        "Existing booking"
    de:        "Bestehende Buchung"
  payment:
    en:        "Invoices & payment"
    de:        "Rechnungen & Zahlung"
  other:
    en:        "General inquiries"
    de:        "Andere Anliegen"

availability:
  ready:       "I'm ready for calls"
  away:        "I'm away from desk"
  busy:        "I'm currently busy"

activity:
  talking:     "I'm talking"
  ringing:     "I'm ringing"
  silent:      "I'm silent"

visibility:
  offline:     "I'm offline"
  online:      "I'm online"

default_tags:
  open:        "Open"
  solved:      "Solved"
  closed:      "Closed"
  pending:     "Pending"
EOF

# The frontend supports up to six different languages/skills.
# If you don't require multiple options, you may remove all
# alternatives but the "d"-entry, which is used as default.
#
default[:agent][:menu] = <<-EOF
language_menu:
  1: de
  2: en
  3: es
  4: fr
  5: it
  d: en

skill_menu:
  1: new_booking
  2: ext_booking
  3: payment
  4: other
  d: other
EOF
