  ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]

  task :master do
    set :url, "master.fluffbox.info"
    set :puppet_pkgs, "puppet puppetmaster facter"
  
    role :server, "#{url}"
  end

  task :web_server do
    set :master_address, "master.fluffbox.info"
    set :url, "www.fluffbox.info"
    set :puppet_pkgs, "puppet facter"
  
    role :server, "#{url}"
  end

  task :db_server do
    set :master_address, "master.fluffbox.info"
    set :url, "db.fluffbox.info"
    set :puppet_pkgs, "puppet facter"
  
    role :server, "#{url}"
  end

  set :user, "root"

  task :setup_master do
    master
    update_apt
    install_ruby
    install_puppet
    configure_master
    update_config
    upload_all_modules
  end

  task :setup_agent do
    update_apt
    install_ruby
    install_puppet
    connect_agent
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

  task :upload_all_modules, roles => :server do
    run "rm -rf /etc/puppet/modules"
    upload "modules", "/etc/puppet/modules"
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

  task :puppet_run, roles => :server do
    run "puppet agent --server=#{master_address} --no-daemonize --verbose --onetime"
  end