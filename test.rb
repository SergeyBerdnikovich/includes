
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

def form_tree_hash(account_id,cat_id = 0)
  cat = $sql.query("SELECT * FROM categories WHERE account_id = 547 AND parent_id = #{cat_id}").to_a
  if cat.size > 0
    tree_hash = Hash.new
    cat.each do |c|
      tree_hash[c['categoryid']] = Hash.new
      tree_hash[c['categoryid']] = form_tree_hash(c['categoryid'])
    end
    return tree_hash
  end
end

def form_list_string(hash)
  ret_str  = "<ul>"
  hash.each do |key, val|
    if val #if there are values thus this item have children. <ul><li> structure required
    ret_str += "<li>category"+form_list_string(val)+"</li>"
    else #only show as one record, <li>...<li>
      ret_str += "<li>category</li>"
    end
  end
  ret_str + "</ul>"
end

EventMachine.synchrony do

  p "starting"

  p "starting1"
  $sql = EventMachine::Synchrony::ConnectionPool.new(size: 2) do
    Mysql2::EM::Client.new(sqlconf)
  end
 p "srtart"
  cat_tree = Hash.new

    cat_tree = form_tree_hash()
    #p cat_tree
    p form_list_string(cat_tree)
    EventMachine.stop


end

