task :master do
  set :ip_address, "50.57.161.196"
  set :password, "pro-puppet-masterLIe13M3kt"
  set :puppet_pkgs, "puppet puppetmaster facter"
  
  role :server, "#{ip_address}"
end

task :agent do
  set :master_address, "50.57.161.196"
  set :ip_address, "50.57.161.200"
  set :password, "pro-puppet-node1r70kKpQK4"
  set :puppet_pkgs, "puppet facter"
  
  role :server, "#{ip_address}"
end

set :user, "root"

task :setup_master do
  master
  install_ruby
  install_puppet
  configure_master
end

task :setup_agent do
  agent
  install_ruby
  install_puppet
  connect_agent
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

task :install_sudo_module, roles => :server do
  template = ERB.new(File.read('site.pp.erb'), nil, '<>')
  result = template.result(binding)
  put(result, "/etc/puppet/manifests/site.pp")
  
  upload 'nodes.pp', '/etc/puppet/manifests/nodes.pp'
  
  run "rm -rf /etc/puppet/modules"
  upload 'modules', '/etc/puppet/modules'
end

task :connect_agent, roles => :server do
  run "puppet agent --server=#{master_address} --no-daemonize --verbose"
end

task :list_certs, roles => :server do
  run "puppet cert --list"
end

task :sign_cert, roles => :server do
  run "puppet cert --sign pro-puppet-node1"
end