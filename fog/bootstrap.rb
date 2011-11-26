require 'rubygems'
require 'fog'

FLAVOR_256_MB = 1
FLAVOR_512_MB = 2

IMAGE_LUCID = 112
IMAGE_NATTY = 115

credentials = {
  :provider           => 'Rackspace',
  :rackspace_username => ENV['RACKSPACE_USERNAME'],
  :rackspace_api_key  => ENV['RACKSPACE_API_KEY']
}

puts "Starting Fluffbox server bootstrap..."

connection = Fog::Compute.new(credentials)
dns = Fog::DNS.new(credentials)

puts "Creating DNS zone for fluffbox.info"
zone = dns.zones.create(
  :domain => 'fluffbox.info',
  :email  => 'matt.stine@gmail.com'
)

server_names = %w(master web db)

servers = {}

server_names.each do |name|
  puts "Starting server build for #{name}."
  servers[name] = connection.servers.bootstrap(
    :flavor_id => FLAVOR_512_MB,
    :image_id => IMAGE_NATTY,
    :name => name,
    :private_key_path => '~/.ssh/id_rsa', 
    :public_key_path => '~/.ssh/id_rsa.pub'
    )
end

servers.each do |name, server|
  server.wait_for { ready? }
  puts "Server #{name} is ready!"
  
  if name == "web"
    puts "Creating primary DNS record and CNAME for web"
    
    zone.records.create(
      :value   => server.public_ip_address,
      :name => "fluffbox.info",
      :type => 'A'
    )
    
    zone.records.create(
      :value   => "fluffbox.info",
      :name => "www.fluffbox.info",
      :type => 'CNAME'
    )
  
  else
    puts "Creating DNS record for #{name}"
    
    zone.records.create(
      :value   => server.public_ip_address,
      :name => "#{name}.fluffbox.info",
      :type => 'A'
    )
  end
    
  puts "Done creating DNS record(s) for #{name}"
end

puts "Fluffbox server bootstrap finished!"