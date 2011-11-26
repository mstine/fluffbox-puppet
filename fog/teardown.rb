require 'rubygems'
require 'fog'

credentials = {
  :provider           => 'Rackspace',
  :rackspace_username => ENV['RACKSPACE_USERNAME'],
  :rackspace_api_key  => ENV['RACKSPACE_API_KEY']
}

puts "Starting Fluffbox server teardown..."

connection = Fog::Compute.new(credentials)
dns = Fog::DNS.new(credentials)

connection.servers.all.each do |server|
  puts "Tearing down server: #{server.name}"
  server.destroy
end

dns.zones.all.each do |zone|
  puts "Tearing down DNS zone: #{zone}"
  zone.destroy
end