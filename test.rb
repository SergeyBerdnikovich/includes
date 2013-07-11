
require 'cgi'
require 'socket'
require 'thread'
#require 'eventmachine'
require "em-synchrony"
#require "mysql2"
require "em-synchrony/mysql2"
require 'em_mysql2_connection_pool'
require 'json'
require 'ipaddr'
require 'digest/md5'
require 'uri'
require 'yaml'

#require 'dbi'
env = 'development'  # taking rails DB configuration, only MySQL supported now
config_rails = YAML.load_file('config/database.yml')
config = YAML.load_file('config/database.yml')
sqlconf = {
  :host => "localhost",
  :database => config[env]['database'],
  :reconnect => true,
  :username => config[env]['username'],
  :password => config[env]['password'],
  :size => 5,
  :reconnect => true,
  :connections => 5
}

$sql = nil

def func
       product = $sql.query("SELECT * FROM products WHERE productid = 2 LIMIT 1")
       return product.to_a
end

def foo
  return func
end

 EventMachine.synchrony do

p "starting"

    p "starting1"
 $sql = EventMachine::Synchrony::ConnectionPool.new(size: 2) do
      Mysql2::EM::Client.new(sqlconf)
    end

  p "result is:"
 p foo


end


def async_fetch(url)
  f = Fiber.current
  http = EventMachine::HttpRequest.new(url).get :timeout => 10
  http.callback { f.resume(http) }
  http.errback { f.resume(http) }

  return Fiber.yield
end

EventMachine.run do
  Fiber.new{
    puts "Setting up HTTP request #1"
    data = async_fetch('http://www.google.com/')
    puts "Fetched page #1: #{data.response_header.status}"

    EventMachine.stop
  }.resume
end
