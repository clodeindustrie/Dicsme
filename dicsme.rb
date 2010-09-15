# dicsme.rb
  require 'rubygems'
  require 'sinatra'
  require 'dm-core'
  require 'dm-validations'
  require 'dm-migrations/adapters/dm-sqlite-adapter'
  require "dm-migrations"
  require "dm-serializer"  
   

  #
  ### CONFIGURATION
  
  configure :development do
    DataMapper.setup(:default, 'sqlite3:db/dicsme.db')
    set :logging, true
    set :raise_errors, true
    DataMapper::Logger.new(STDOUT, :debug)
  end
  
  configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
    
    set :raise_errors, true
  end
  
    # 
    # #
    # ### MODELS
    # #  
    #
    
    class LP
      include DataMapper::Resource

      property :id,         Serial
      property :UUID,       String,  :required => true, :key => true, :unique => true
      property :identifier, String,  :required => true, :key => true, :unique => true
      
      property :created_at, DateTime
      property :updated_at, DateTime
      
    end
    
    DataMapper.finalize
    
    
    #
    # # Actions for the Daemon side
    #
    
    
    get '/app/:uid' do
      
      lp = LP.first( :UUID => params[:uid])
    
      play(lp.id)
    end
    
    get '/dis/:uid' do
      
      lp = LP.first( :UUID => params[:uid])
      
      stop(id)
    end
    
    
    get '/' do
      "Default page"
    end
    
    #
    # # Actions for XBMC
    #
    
    get '/list' do
      LP.all.to_json( :only => [:UUID, :identifier])
    end
    
    get '/track/:id' do
      LP.all( :identifier => params[:id] ).to_json( :only => [:UUID, :identifier])
    end
    
    post '/add' do
      lp = LP.new(
        :UUID       => params[:uid],
        :identifier => params[:id],
        :created_at => Time.now,
        :updated_at => Time.now
      )
      
      if lp.save
        "[{ 'success' => 'Album saved' }]"
      else
        lp.errors
      end
    end
    
    delete '/:id' do
      lp = LP.first( :identifier => params[:id] )
      
      if !lp.nil?
        lp.destroy
        "[{ 'success' => 'Album deleted' }]"
      else
        "[{ 'error' => 'Paire Doesn\'t exist' }]"
      end      
    end
    
    
    #
    # # misc functions
    #
    
    def play(id)
      
    end
    
    def stop(id)
      
    end
    
    def toAdd(uid)
      
    end
      