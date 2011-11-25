task :master do
  set :ip_address, "50.57.188.170"
  set :password, "puppet-masterm4SdAgR27"
  set :puppet_pkgs, "puppet puppetmaster facter"
  
  role :server, "#{ip_address}"
end

task :web_server do
  set :master_address, "50.57.188.170"
  set :ip_address, "50.57.232.216"
  set :password, "fluffbox-web2awQp6S3O"
  set :puppet_pkgs, "puppet facter"
  
  role :server, "#{ip_address}"
  
  setup_agent
end

task :db_server do
  set :master_address, "50.57.188.170"
  set :ip_address, "50.57.232.229"
  set :password, "fluffbox-db7ArpP46kH"
  set :puppet_pkgs, "puppet facter"
  
  role :server, "#{ip_address}"
  
  setup_agent
end

set :user, "root"

task :setup_master do
  master
  update_apt
  install_ruby
  install_puppet
  configure_master
end

task :setup_agent do
  update_apt
  install_ruby
  install_puppet
  connect_agent
end

task :serverless_agent do
  agent
  install_ruby
  install_puppet
end

task :update_apt, roles => :server do
  run "apt-get update"
end

task :install_ruby, roles => :server do
  run "apt-get -y install ruby libshadow-ruby1.8"
end

task :install_puppet, roles => :server do
  run "apt-get -y install #{puppet_pkgs}"
end

task :configure_master, roles => :server do
  template = ERB.new(File.read('puppet.conf.erb'), nil, '<>')
  result = template.result(binding)
  put(result, "/etc/puppet/puppet.conf")
  
  run "touch /etc/puppet/manifests/site.pp"
  
  run "service puppetmaster restart"
end

task :update_config, roles => :server do
  template = ERB.new(File.read('site.pp.erb'), nil, '<>')
  result = template.result(binding)
  put(result, "/etc/puppet/manifests/site.pp")
  
  upload 'nodes.pp', '/etc/puppet/manifests/nodes.pp'
end

task :install_module, roles => :server do  
  run "rm -rf /etc/puppet/modules/#{module_name}"
  upload "modules/#{module_name}", "/etc/puppet/modules/#{module_name}"
end

task :connect_agent, roles => :server do
  run "puppet agent --server=#{master_address} --no-daemonize --verbose"
end

task :list_certs, roles => :server do
  run "puppet cert --list"
end

task :sign_cert, roles => :server do
  run "puppet cert --sign #{node}"
end