class BigcommerceAccount < ActiveRecord::Base
  attr_accessible :api_key, :store_url, :username
  validates :api_key, :presence => true, :length => { :minimum => 5 }
  validates :store_url, :presence => true, :length => { :minimum => 10 }
  validates :username, :presence => true, :length => { :minimum => 1 }
  belongs_to :account

  attr_accessor :name

  extend FriendlyId
  friendly_id :name, use: :slugged


  def name
    self.account.name
  end


  def self.download_data(bigcommerce_acc)
    require 'bigcommerce'
    @bigcommerce = bigcommerce_acc #BigcommerceAccount.find(params[:id])
    @account_id = @bigcommerce.account.id

    @pool = Thread.pool(4)  #thread pool to process requests multhithreaded

    api = Bigcommerce::Api.new({
      :store_url => @bigcommerce.store_url,
      :username  => @bigcommerce.username,
      :api_key   => @bigcommerce.api_key
    })
    @test = api.get_brands
     Brand.where("account_id = ?",@account_id).delete_all
    @test.each do |brand|
      p "brand " + brand["id"].to_s
      if brand["name"].blank? == false
        @brand = Brand.where("account_id = ? AND brandid = ?", @account_id, brand["id"]).first
        @pool.process {
          if @brand
            @brand.update_attributes(:brandid => brand["id"], :name => brand["name"],:page_title => brand["page_title"],:meta_keywords => brand["meta_keywords"],:meta_description => brand["meta_description"],:image_file => brand["image_file"],:search_keywords => brand["search_keywords"])
            @brand.save
          else
            Brand.new(:account_id => @account_id, :brandid => brand["id"], :name => brand["name"],:page_title => brand["page_title"],:meta_keywords => brand["meta_keywords"],:meta_description => brand["meta_description"],:image_file => brand["image_file"],:search_keywords => brand["search_keywords"]).save
          end
        }
      end
    end
    prods = 1
    offset = 1 
    Product.where("account_id = ?",@account_id).delete_all
      begin
      @test = api.get_products('limit' => 200, 'page' => offset)
      prods = 0
      @test.each do |product|
        @pool.process {
          prods += 1
          p product["id"]
          @product = Product.where("account_id = ? AND productid = ?", @account_id, product["id"]).first
          if @product
            if @product.updated_at != product['date_modified']
              @product.update_attributes(:name => product["name"],:type => product["type"],:sku => product["sku"],:description => product["description"],:availability => product["availability"],:availability_description => product["availability_description"],:price => product["price"],:cost_price => product["cost_price"],:retail_price => product["retail_price"],:sale_price => product["sale_price"],:calculated_price => product["calculated_price"],:inventory_level => product["inventory_level"],:warranty => product["warranty"],:weight => product["weight"],:width => product["width"],:height => product["height"],:depth => product["depth"],:total_sold => product["total_sold"],:date_created => product["date_created"],:brand_id => product["brand_id"],:view_count => product["view_count"],:page_title => product["page_title"],:date_modified => product["date_modified"],:condition => product["condition"],:upc => product["upc"],:custom_url => product["custom_url"], :updated_at => product['date_modified'], :processed => false)
              @product.save
            end
          else
            Product.new(:account_id => @account_id, :productid => product["id"],:name => product["name"],:type => product["type"],:sku => product["sku"],:description => product["description"],:availability => product["availability"],:availability_description => product["availability_description"],:price => product["price"],:cost_price => product["cost_price"],:retail_price => product["retail_price"],:sale_price => product["sale_price"],:calculated_price => product["calculated_price"],:inventory_level => product["inventory_level"],:warranty => product["warranty"],:weight => product["weight"],:width => product["width"],:height => product["height"],:depth => product["depth"],:total_sold => product["total_sold"],:date_created => product["date_created"],:brand_id => product["brand_id"],:view_count => product["view_count"],:page_title => product["page_title"],:date_modified => product["date_modified"],:condition => product["condition"],:upc => product["upc"],:custom_url => product["custom_url"], :updated_at => product['date_modified'], :processed => false).save
          end
        }
      end
      offset += 1
    rescue Exception => e
      p e
      p e.backtrace
      prods = 0
    end while prods != 0



    #categories
    offset = 1
    begin
      @test = api.get_categories('limit' => 250, 'page' => offset)
      Category.where("account_id = ?",@account_id).delete_all
      prods = 0

      @test.each do |category|
        prods += 1
        if category["name"].blank? == false
          p "category #{category["id"]}"
          @cat = Category.where("account_id = ? AND categoryid = ?", @account_id, category["id"]).first
          @pool.process {

            if @cat
              @cat.update_attributes(:parent_id => category["parent_id"],:name => category["name"],:description => category["description"],:page_title => category["page_title"],:image_file => category["image_file"],:image_tag => category["image_tag"],:url => category["url"])
              @cat.save
            else
              Category.new(:account_id => @account_id, :categoryid => category["id"],:parent_id => category["parent_id"],:name => category["name"],:description => category["description"],:page_title => category["page_title"],:image_file => category["image_file"],:image_tag => category["image_tag"],:url => category["url"] ).save
            end
          }
        end
      end
      offset += 1
    rescue Exception => e
      p e
      p e.backtrace
      prods = 0
    end while prods != 0

    @products = Product.where('account_id = ? AND processed != 1 OR account_id = ? AND processed IS NULL',@account_id,@account_id).limit(5)

    begin
      p "products size #{@products.size}"
      @products.each do |product|
        p  "images for #{product["productid"]}"

        @pool.process {
          begin
            @img = api.get_product_images(product["productid"].to_i)
          rescue Exception => e
          end
          if @img

            @img.each do |image|
              p  "image #{image["id"]}"
              if image["image_file"].blank? == false
                @image = Image.where("account_id = ? AND imageid = ?", @account_id, image["id"]).first
                if @image
                  @image.update_attributes(:account_id => @account_id, :imageid => image["id"],:account_id => image["account_id"],:productid => product["productid"],:image_file => image["image_file"],:description => image["description"])
                  @image.save
                else
                  img = Image.new(:account_id => @account_id, :imageid => image["id"],:account_id => image["account_id"],:productid => product["productid"],:image_file => image["image_file"],:description => image["description"])
                  img.update_attribute(:account_id => @account_id)
                  img.save
                end
              end
            end
          end
        }

        product.update_attribute(:processed, 1)
        product.save
      end
      @products = Product.where('account_id = ? AND processed != 1 OR account_id = ? AND processed IS NULL',@account_id,@account_id).limit(5)
    end while @products.size != 0


  end
end


require 'thread'

# A pool is a container of a limited amount of threads to which you can add
# tasks to run.
#
# This is usually more performant and less memory intensive than creating a
# new thread for every task.
class Thread::Pool
  # A task incapsulates a block being ran by the pool and the arguments to pass
  # to it.
  class Task
    Timeout = Class.new(Exception)
    Asked   = Class.new(Exception)

    attr_reader :pool, :timeout, :exception, :thread, :started_at

    # Create a task in the given pool which will pass the arguments to the
    # block.
    def initialize (pool, *args, &block)
      @pool      = pool
      @arguments = args
      @block     = block

      @running    = false
      @finished   = false
      @timedout   = false
      @terminated = false
    end

    def running?;    @running;   end
    def finished?;   @finished;   end
    def timeout?;    @timedout;   end
    def terminated?; @terminated; end

    # Execute the task in the given thread.
    def execute (thread)
      return if terminated? || running? || finished?

      @thread     = thread
      @running    = true
      @started_at = Time.now

      pool.__send__ :wake_up_timeout

      begin
        @block.call(*@arguments)
      rescue Exception => reason
        if reason.is_a? Timeout
          @timedout = true
        elsif reason.is_a? Asked
          return
        else
          @exception = reason
        end
      end

      @running  = false
      @finished = true
      @thread   = nil
    end

    # Raise an exception in the thread used by the task.
    def raise (exception)
      @thread.raise(exception)
    end

    # Terminate the exception with an optionally given exception.
    def terminate! (exception = Asked)
      return if terminated? || finished? || timeout?

      @terminated = true

      return unless running?

      self.raise exception
    end

    # Force the task to timeout.
    def timeout!
      terminate! Timeout
    end

    # Timeout the task after the given time.
    def timeout_after (time)
      @timeout = time

      pool.timeout_for self, time

      self
    end
  end

  attr_reader :min, :max, :spawned

  # Create the pool with minimum and maximum threads.
  #
  # The pool will start with the minimum amount of threads created and will
  # spawn new threads until the max is reached in case of need.
  #
  # A default block can be passed, which will be used to {#process} the passed
  # data.
  def initialize (min, max = nil, &block)
    @min   = min
    @max   = max || min
    @block = block

    @cond  = ConditionVariable.new
    @mutex = Mutex.new

    @todo     = []
    @workers  = []
    @timeouts = {}

    @spawned       = 0
    @waiting       = 0
    @shutdown      = false
    @trim_requests = 0
    @auto_trim     = false

    @mutex.synchronize {
      min.times {
        spawn_thread
      }
    }
  end

  # Check if the pool has been shut down.
  def shutdown?; !!@shutdown; end

  # Check if auto trimming is enabled.
  def auto_trim?
    @auto_trim
  end

  # Enable auto trimming, unneeded threads will be deleted until the minimum
  # is reached.
  def auto_trim!
    @auto_trim = true
  end

  # Disable auto trimming.
  def no_auto_trim!
    @auto_trim = false
  end

  # Resize the pool with the passed arguments.
  def resize (min, max = nil)
    @min = min
    @max = max || min

    trim!
  end

  # Get the amount of tasks that still have to be run.
  def backlog
    @mutex.synchronize {
      @todo.length
    }
  end

  # Add a task to the pool which will execute the block with the given
  # argument.
  #
  # If no block is passed the default block will be used if present, an
  # ArgumentError will be raised otherwise.
  def process (*args, &block)
    unless block || @block
      raise ArgumentError, 'you must pass a block'
    end

    task = Task.new(self, *args, &(block || @block))

    @mutex.synchronize {
      raise 'unable to add work while shutting down' if shutdown?

      @todo << task

      if @waiting == 0 && @spawned < @max
        spawn_thread
      end

      @cond.signal
    }

    task
  end

  alias << process

  # Trim the unused threads, if forced threads will be trimmed even if there
  # are tasks waiting.
  def trim (force = false)
    @mutex.synchronize {
      if (force || @waiting > 0) && @spawned - @trim_requests > @min
        @trim_requests -= 1
        @cond.signal
      end
    }

    self
  end

  # Force #{trim}.
  def trim!
    trim true
  end

  # Shut down the pool instantly without finishing to execute tasks.
  def shutdown!
    @mutex.synchronize {
      @shutdown = :now
      @cond.broadcast
    }

    wake_up_timeout

    self
  end

  # Shut down the pool, it will block until all tasks have finished running.
  def shutdown
    @mutex.synchronize {
      @shutdown = :nicely
      @cond.broadcast
    }

    join

    if @timeout
      @shutdown = :now

      wake_up_timeout

      @timeout.join
    end

    self
  end

  # Join on all threads in the pool.
  def join
    until @workers.empty?
      if worker = @workers.first
        worker.join
      end
    end

    self
  end

  # Define a timeout for a task.
  def timeout_for (task, timeout)
    unless @timeout
      spawn_timeout_thread
    end

    @mutex.synchronize {
      @timeouts[task] = timeout

      wake_up_timeout
    }
  end

  # Shutdown the pool after a given amount of time.
  def shutdown_after (timeout)
    Thread.new {
      sleep timeout

      shutdown
    }

    self
  end

  private
  def wake_up_timeout
    if defined? @pipes
      @pipes.last.write_nonblock 'x' rescue nil
    end
  end

  def spawn_thread
    @spawned += 1

    thread = Thread.new {
      loop do
        task = @mutex.synchronize {
          if @todo.empty?
            while @todo.empty?
              if @trim_requests > 0
                @trim_requests -= 1

                break
              end

              break if shutdown?

              @waiting += 1
              @cond.wait @mutex
              @waiting -= 1
            end

            break if @todo.empty? && shutdown?
          end

          @todo.shift
        } or break

        task.execute(thread)

        break if @shutdown == :now

        trim if auto_trim? && @spawned > @min
      end

      @mutex.synchronize {
        @spawned -= 1
        @workers.delete thread
      }
    }

    @workers << thread

    thread
  end

  def spawn_timeout_thread
    @pipes   = IO.pipe
    @timeout = Thread.new {
      loop do
        now     = Time.now
        timeout = @timeouts.map {|task, time|
          next unless task.started_at

          now - task.started_at + task.timeout
        }.compact.min unless @timeouts.empty?

        readable, = IO.select([@pipes.first], nil, nil, timeout)

        break if @shutdown == :now

        if readable && !readable.empty?
          readable.first.read_nonblock 1024
        end

        now = Time.now
        @timeouts.each {|task, time|
          next if !task.started_at || task.terminated? || task.finished?

          if now > task.started_at + task.timeout
            task.timeout!
          end
        }

        @timeouts.reject! { |task, _| task.terminated? || task.finished? }

        break if @shutdown == :now
      end
    }
  end
end

class Thread
  # Helper to create a pool.
  def self.pool (*args, &block)
    Thread::Pool.new(*args, &block)
  end
end