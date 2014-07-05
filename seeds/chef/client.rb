current_dir = File.dirname(__FILE__)

log_level                :info
log_location             STDOUT
node_name                "voice00"
cache_type               "BasicFile"
ssl_verify_mode          :verify_peer
validation_client_name   "wimdu-voice-validator"
client_key               "#{current_dir}/voice00.pem"
validation_key           "#{current_dir}/wimdu-voice-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/wimdu-voice"
