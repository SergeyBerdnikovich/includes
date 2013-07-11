#!/usr/bin/env ruby
# encoding: utf-8

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

Server_threads = 1 #in fact, separate processes. Ruby have green threads
#which are unable to take advantage of multicore servers. Having separate process
#we overcoming this issue



include Socket::Constants #working with sockets at the lowest possible level
$socket = Socket.new( AF_INET, SOCK_STREAM, 0 ) #result efectiveness doesen't differ from using c++
sockaddr = Socket.pack_sockaddr_in( 2200, '0.0.0.0' )
$socket.bind( sockaddr )
$socket.listen( 5 )

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


# for working with unix socket

#include Socket::Constants
#sock_path = '/tmp/ruby_advadv.sock'
#File.unlink(sock_path) if File.exists?(sock_path) && File.socket?(sock_path)
#sockaddr = Socket.sockaddr_un(sock_path)
#puts sockaddr
#sockaddr = Socket.sockaddr_un(sock_path)
#$socket = Socket.new(AF_UNIX, SOCK_STREAM, 0 )
#$socket.bind( sockaddr )
#$socket.listen( 2500 )
#File.chmod(0666, sock_path)

#registering shortcode functions

def parse_attributes(body)
  attributes = Hash.new
  body.scan(/([\w_-]*)\s{0,2}=\s{0,2}['"`]{0,1}([^\[\]'"`]*?)[\s'"`\]]+/).each do |attribute|
    attributes[attribute[0]] =  attribute[1]
  end
  attributes
end

def parse_requests(body)
  requests = Array.new
  body.scan(/show\s{0,2}=\s{0,2}['`"]{0,1}([^\[\]'"`]+?)[\s'"`\]]+|{([a-zA-Z_\-0-9]+)}|\s([a-zA-Z0-9_\-]+)(?=\s|\/|\])/).each do |request|
    request.each do |match|
      requests.push(match) if match #adding non nil group that were found in body
    end
  end
  requests
end




class Server < EM::Connection
  def initialize socket
    self.notify_readable = true
    @socket = socket
    @sql = nil #sql connector object
    @accounts = nil #hash in format -  accounts_api_key -> account .
    @accounts_id = nil #hash in format -  accounts_id -> account .
    @includes = nil #hash in format - include_api_key -> include_hash
    @includes_id = nil #hash in format - include_id -> include_hash
    @options = nil  #hash in format - user_id -> options_names -> values
    @brands = nil  #hash in format - user_id -> options_names -> values
    @categories = nil
    @products = nil
    @stat = Hash.new  #statistic hash
    @month_stat = nil  #statistic for month grouped by account_id
    @plans = nil  #hash with plans
    @brands_id = nil #hash with brands by id
    @limits = nil
  end


  def process_shortcode(code, account_id, object = nil,object_id = nil)
    p "processing shortcode"
    #workaround to process standalone requests  for object
    #workaround very tricky to process requests like [category id=3] {url} [/category] {tag} - to process category separately and tag separetely for calling object (for example product)
    if object != nil  #clear string from shortcode as tag like [tag]{name}[/tag] to left only {image} for example stanging out of tag
      cleared_string = code.gsub(/(?<=\])[^\[]*(?=\[\/\w{0,20}\])/m){|match|
        replace_str = ""
        match.length.times{
          replace_str += "?"
        }
        replace_str
      } #we replace all shortcodes that could interact in temproary string with ??? and then search there for requests coordinats and then replace real string
      standalone_requests = cleared_string.enum_for(:scan, /\{[a-zA-Z_\-]{2,35}\}/).map { [Regexp.last_match.begin(0),Regexp.last_match.end(0),Regexp.last_match] }
      standalone_requests.reverse.each{|coords|
        shortcode = "[#{object} id='#{object_id}']#{coords[2].to_s}[/#{object}]"
        shortcode = process_simple_shortcode(shortcode, account_id)
        p shortcode
        code = code[0,coords[0]] + shortcode + code[coords[1],code.length - coords[1] ]
      }
      code = process_simple_shortcode(code, account_id)
      return code
    else
      p "object is nil"
    end
  end

  def process_simple_shortcode(code, account_id)
    possible_shortcodes = 'brand|product|category'
    #code.gsub!(/(\[(\w{1,90})[\w'"0-9=\s]*?\][^\[\]]*?\[\/\w*\])|(\[(\w{1,90})[\w'"0-9=\s]*?[\/\s]{0,2}\])/) do |shortcode| #variant that catches all shortcodes
    code.gsub!(/(\[(#{possible_shortcodes})[\w'"0-9=\s]*?\][^\[\]]*?\[\/(?:#{possible_shortcodes})\])|(\[(\w{1,90})[\w'"0-9=\s]*?[\/\s]{0,2}\])/) do |shortcode| #variant that catches only predefined shortcodes - for speed
      p shortcode
      name = shortcode.match(/(?:\[)([a-zA-Z_-]{1,90})/)[1]

      attributes = parse_attributes(shortcode)

      if attributes["id"] #if there is no ID attribute no sense to continue
        requests = parse_requests(shortcode)
        text = ""
        case name
        when "brand"
          p "brand "
          text = shortcode_brands(account_id, attributes, requests)
        when "product"
          text = shortcode_products(account_id, attributes, requests)
        when "category"
          p "category"
          text = shortcode_categories(account_id, attributes, requests)
        else #suppose to work only with "catches all" regex
          "<!-- Incorrect shortcode - #{name} -->"
        end
      else
        "<!-- no id attribute specified -->"
      end
      p text
      text
    end
    p "returning"
    p code
    code
  end

  def shortcode_brands(account_id, attributes, requests)
    brand = @sql.query("SELECT * FROM brands WHERE account_id = #{account_id} AND brandid = #{attributes["id"].to_i} LIMIT 1")
    brand = brand.to_a #make result an array
    if brand.size != 0
      brand = brand[0] # take first result
      return_value = ""
      requests.each do |req|
        case req
        when "asdad"
        else  # to access general text fields
          if brand[req]
            return_value += brand[req].to_s
          end
        end
      end
      return return_value
    else
      "<!-- brand #{attributes["id"]} wasn't found -->"
    end
  end

  def shortcode_products(account_id, attributes, requests)
    product = @sql.query("SELECT * FROM products WHERE account_id = #{account_id} AND productid = #{attributes["id"].to_i} LIMIT 1")
    product = product.to_a #make result an array
    if product.size != 0
      product = product[0] # take first result
      return_value = ""
      requests.each do |req|
        case req

        when /url_tag/

          return_value +="<a href='#{@accounts_id[account_id]['store_url'] + product['custom_url']}'>Link to #{product['name']}</a>"

        when /image_file[_0-9]*?/i

          id = req.match(/(?:image_file_)(\d*)/m)
          if id
            id = id[1]
          else
            id = 0
          end
          image = @sql.query("SELECT * FROM images WHERE productid = #{product["productid"]} AND account_id = #{account_id} LIMIT 1 OFFSET #{id}")
          p "SELECT * FROM images WHERE productid = #{product["productid"]} AND account_id = #{account_id} LIMIT 1 OFFSET #{id}"
          image = image.to_a
          p image
          if image.size != 0
            p "image size ok"
            return_value += @accounts_id[account_id]['store_url'] + '/product_images/' + image[0]['image_file']
            p @accounts_id[account_id]['store_url'] + '/product_images/' + image[0]['image_file']
          end

        when /image_tag[_0-9]*?/i

          id = req.match(/(?:image_tag_)(\d*)/m)
          if id
            id = id[1]
          else
            id = 0
          end
          image = @sql.query("SELECT * FROM images WHERE productid = #{product["productid"]} AND account_id = #{account_id} LIMIT 1 OFFSET #{id}")
          p "SELECT * FROM images WHERE productid = #{product["productid"]} AND account_id = #{account_id} LIMIT 1 OFFSET #{id}"
          image = image.to_a
          p image
          if image.size != 0
            p "image size ok"
            return_value += '<img src="' + @accounts_id[account_id]['store_url'] + '/product_images/' + image[0]['image_file'] + '" />'

          end



        else  # to access general text fields
          if product[req]
            return_value += product[req].to_s
          end
        end
      end
      return return_value
    else
      "<!-- product #{attributes["id"]} wasn't found -->"
    end
  end

  def shortcode_categories(account_id, attributes, requests)
    category = @sql.query("SELECT * FROM categories WHERE account_id = #{account_id} AND categoryid = #{attributes["id"].to_i} LIMIT 1")
    category = category.to_a #make result an array
    if category.size != 0
      category = category[0] # take first result
      return_value = ""
      requests.each do |req|
        case req
        when "asdad"
        else  # to access general text fields
          if category[req]
            return_value += category[req].to_s
          end
        end
      end
      return return_value
    else
      "<!-- category #{attributes["id"]} wasn't found -->"
    end
  end

  def notify_readable  #this function will be called when there is connectcion attempt on port we are watching for
    client_socket = @socket.accept_nonblock[0]
    process_request(client_socket)
  end

  def config_sql config  #initialize SQL instance
    #Mysql2::Client.default_query_options.merge! :symbolize_keys => true, :cast_booleans => true
    #@sql = EmMysql2ConnectionPool.new config
    @sql = EventMachine::Synchrony::ConnectionPool.new(size: 100) do
      Mysql2::EM::Client.new(config)
    end

    form_db_variables
    process_statistics
  end

  def form_db_variables  #function to form variables that would be used instead of DB
    Fiber.new{
      res = @sql.query("SELECT accounts.*, bigcommerce_accounts.store_url FROM accounts, bigcommerce_accounts WHERE bigcommerce_accounts.account_id = accounts.id") # form user hash
      @accounts = Hash.new
      @accounts_id = Hash.new
      res.to_a.each do |account|
        @accounts[account["api_key"]] = account
        @accounts_id[account["id"]] = account
      end
      p @accounts


      res = @sql.query("SELECT * FROM includes") # form includes hash
      @includes = Hash.new
      @includes_id = Hash.new
      res.to_a.each do |inc|
        if inc["include_file"]
          if inc["include_file"].size > 3
            begin
              file_name = "public/uploads/include/include_file/#{inc["id"]}/#{inc["include_file"]}"
              inc["content"] = File.read(file_name)
            rescue Exception => e
              p e
              p e.backtrace
            end
          end
        end
        @includes[inc["api_key"]] = inc
        @includes_id[inc["id"]] = inc
      end


      res = @sql.query("SELECT * FROM plans") # form includes hash

      @plans = Hash.new
      res.to_a.each do |inc|
        @plans[inc["id"]] = inc
      end

      res = @sql.query("SELECT * FROM brands") # form includes hash
      @brands_id = Hash.new
      res.to_a.each do |inc|
        @brands_id[inc["brandid"]] = inc
      end
      p @brands_id

      res = @sql.query("SELECT * FROM categories") # form includes hash
      @categories = Hash.new
      res.to_a.each do |inc|
        @categories[inc["categoryid"]] = inc
      end


      res = @sql.query("SELECT * FROM products") # form includes hash
      @products = Hash.new
      res.to_a.each do |inc|
        @products[inc["productid"]] = inc
      end






      res = @sql.query("SELECT include_options.*, options.* FROM include_options LEFT JOIN options ON options.id = include_options.option_id") # form includes options and brand hash
      @options = Hash.new
      @brands = Hash.new
      res.to_a.each do |inc|
        @options[inc["include_id"]] = Hash.new if @options[inc["include_id"]] == nil
        @options[inc["include_id"]][inc["name"]] = inc["value"]


        if inc["name"] =~ /brand_id/ #if option is brand forming brand array
          account_id = @includes_id[inc["include_id"].to_i]["account_id"] if @includes_id[inc["include_id"].to_i]
          if account_id != nil
            @brands[account_id] = Hash.new if @brands[account_id] == nil
            @brands[account_id][inc["value"]] = inc["include_id"]
          else
          end
        elsif inc["name"] =~ /category_id/
          account_id = @includes_id[inc["include_id"].to_i]["account_id"].to_s if @includes_id[inc["include_id"].to_i]
          if account_id != nil
            @categories["acc"+account_id] = Hash.new if @categories["acc"+account_id] == nil
            @categories["acc"+account_id][inc["value"]] = inc["include_id"]
          else
          end
        elsif inc["name"] =~ /product_id/
          account_id = @includes_id[inc["include_id"].to_i]["account_id"].to_s if @includes_id[inc["include_id"].to_i]
          if account_id != nil
            @products["acc"+account_id] = Hash.new if @products["acc"+account_id] == nil
            @products["acc"+account_id][inc["value"]] = inc["include_id"]
          else
          end
        end

      end
      p @brands
    }.resume

  end

  def socket_reply(socket,code,data) #function to send reply to a socket and handle low level communication
    p "replying"
    case code
    when "redirect"
      text="
      <html>
      <head>
      <title>Moved</title>
      </head>
      <body>
      <h1>Moved</h1>
      <p>This page has moved to <a href='#{data}'>#{data}</a>.</p>
      </body>
      </html>"

      socket.write "HTTP/1.1 301 Moved Permanently\r\nLocation: #{data}\r\nServer: Includes.io\r\nContent-Length: #{data.length}\r\nContent-type: text/html\r\nConnection: close\r\n\r\n#{text}"
    else
      p data
      data.gsub!(/[^a-zA-Z0-9~!@\x23$%^ \s&*()·!"#¤%&\/(\[\]}{)=<\->\?\/.,!"№;%:?*()_+]/m,"")
      p data
      socket.write "HTTP/1.1 200 OK\r\nServer: Includes.io\r\nContent-Length: #{data.length}\r\nContent-type: text/html\r\nConnection: close\r\n\r\n#{data}"
    end

    socket.flush
    socket.close
  end

  def process_statistics #saving statistics from the hash and form limits hash
    Fiber.new{
      year = Time.now.year.to_s
      month = Time.now.month.to_s
      day = Time.now.day.to_s
      month = "0" + month if month.to_s.length == 1
      day = "0" + day if day.to_s.length == 1
      date = year + month + day

      if @accounts_id
        @accounts_id.each do |i,acc|  #checking if accounts are at the limits
          p acc
          self.check_limits(acc["id"],nil,date)
        end
      end
      if @stat.size != 0
        @stat.each do |id|

          res = @sql.query("SELECT * FROM statistics WHERE views = #{id[1]} AND date = #{date} AND include_id = #{id[0]}")
          result = res
          if result.to_a.size != 0
            @sql.aquery("UPDATE statistics SET views = views + #{id[1]} WHERE date = #{date} AND include_id = #{id[0]}")

          else
            @sql.query("INSERT INTO statistics (views, date, include_id)  VALUES (#{id[1]}, #{date}, #{id[0]}) ")
          end
          #  }
        end
      end

      sdate = year + month
      result = @sql.query("SELECT SUM(statistics.views) as views, includes.account_id FROM statistics, includes WHERE date >= #{sdate}01 AND date <= #{sdate}31 AND includes.id = statistics.include_id GROUP BY includes.account_id")

      @month_stat = Hash.new
      result.to_a.each do |res|
        @month_stat[res["account_id"]] = res["views"].to_i if res["account_id"]
      end
      p @month_stat

      @stat = Hash.new
    }.resume
  end

  def tick_counters(id)
    if @stat[id] == nil
      @stat[id] = 1
    else
      @stat[id] += 1
    end

  end

  def check_limits(account_id, socket = nil,date = nil) #check limits and send alerts
    plan_id =  @accounts_id[account_id]["plan_id"]
    p plan_id
    if plan_id && @month_stat[account_id]
      p @plans[plan_id]["impressions"]
      if @month_stat[account_id] > @plans[plan_id]["impressions"] && @plans[plan_id]["impressions"] != 0
        p "LIMIT!"
        if socket != nil  # if request with socket - answer in socket but don't use sql
          self.socket_reply(socket,"y","<!--request limit reached -->")
        else # if call out of user request (that one happends each 30 seconds) then use sql
          check = @sql.query("SELECT * FROM alerts WHERE `alert_type` = 'limit_reached' AND `account_id` = #{account_id} AND `date` = #{date}")
          res = check
          if res.to_a.size == 0
            @sql.query("INSERT INTO alerts (alert_type, account_id, date) VALUES ('limit_reached', #{account_id}, #{date})")
          end
          #  end
        end
        return false
      end

    end

    return true
  end

  def check_date(include_id)


    if @options[include_id]


      if @options[include_id]['date_start']
        return false if DateTime.now < DateTime.strptime(@options[include_id]['date_start'],"%m/%d/%Y")
      end
    end

    if @options[include_id]
      if @options[include_id]['date_end']
        return false if DateTime.now > DateTime.strptime(@options[include_id]['date_end'],"%m/%d/%Y")
      end
    end

    return true
  end

  def process_request(socket)
    p "starting fiber"
    Fiber.new{
      p "fiber started"
      begin
        headers = ""
        while line = socket.gets  #we are getting headers, where get variables are located
          headers << line
          break if line == "\r\n"
        end
        s = /(?:\/)(.*?)(?= )/.match(headers)[1] #and forming habitual hash

        request_ok = true #if request OK then we will process it, if not show error text
        reply = true #if reply was done in parallel fiber we don't need to reply here
        error_text = ""
        include_id = 0
        account_id = nil
        message_text = "" #successfull message text
        params = s.to_s.split("/")
        p params
        api_key = params[params.length - 1]



        if params[0] == 'id'  #checking credentials
          if @includes[api_key]
            account_id = @includes[api_key]["account_id"]
          else
            request_ok == false
            error_text = "Wrong api key"
          end
        else
          if @accounts[api_key]
            account_id = @accounts[api_key]["id"]
          else
            request_ok == false
            error_text = "Wrong api key"
          end
        end  #  end of checking credentials

        if account_id != nil
          unless check_limits(account_id,socket)
            request_ok == false
            reply = false
          end
        else
          self.socket_reply(socket,"redirect","http://includes.io/")
          request_ok == false
          reply = false
        end

        if request_ok #if api key presents then starting to process request
          case params[0]
          when "id"
            data = @includes[api_key]
            tick_counters(data["id"])

            if check_date(data["id"])
              message_text = process_shortcode(data["content"],account_id)
            else
              message_text = "<!--include out of allowed date scope -->"
            end

          when "brand"
            begin
              include_id = @brands[account_id.to_i][params[1]]

              p account_id
              p include_id

              inc = @includes_id[include_id]
              if check_date(include_id)
                message_text = process_shortcode(inc["content"],account_id,"brand",params[1])
              else
                message_text = "<!--include out of allowed date scope -->"
              end

              tick_counters(inc["id"])
            rescue Exception => e
              p e
              p e.backtrace
              message_text = "<no data>"
            end
          when "category"
            begin
              include_id = @categories["acc"+account_id.to_s][params[1]]
              p account_id
              p include_id
              inc = @includes_id[include_id]
              if check_date(include_id)
                message_text = process_shortcode(inc["content"],account_id,"category",params[1])
              else
                message_text = "<!--include out of allowed date scope -->"
              end
              tick_counters(inc["id"])
            rescue Exception => e
              p e
              p e.backtrace
              message_text = "<no data>"
            end
          when "product"
            begin
              include_id = @products["acc"+account_id.to_s][params[1]]
              p account_id
              p include_id
              inc = @includes_id[include_id]
              if check_date(include_id)
                message_text = process_shortcode(inc["content"],account_id,"product",params[1])
              else
                message_text = "<!--include out of allowed date scope -->"
              end
              tick_counters(inc["id"])
            rescue Exception => e
              p e
              p e.backtrace
              message_text = "<no data>"
            end

          else
            message_text = "Wrong request"

          end

          self.socket_reply(socket,"y",message_text)
        else
          if reply == true
            self.socket_reply(socket,"y","<--#{error_text}--!>")
          end
        end

      rescue Exception => e
        puts e
        puts e.backtrace
      end


    }.resume
  end


end




puts "Server started"

Server_threads.times{|i|

  EM.fork_reactor do  #in fact it is clone of already existant process. Ruby have light "green" threads and unable to use several CPUs, this way we remove this limit without any issues.
    EventMachine.synchrony do
      Fiber.new{
        api_server = EM.watch $socket, Server,$socket
        api_server.notify_readable = true
        api_server.config_sql sqlconf
        EM.add_periodic_timer(30) do
          api_server.form_db_variables
          api_server.process_statistics
        end
      }.resume
    end
  end
}


EventMachine.synchrony do

end