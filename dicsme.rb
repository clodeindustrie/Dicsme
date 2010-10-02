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
      property :UID,       String,  :required => true, :key => true, :unique => true
      property :identifier, String,  :required => true, :key => true, :unique => true
      
      property :created_at, DateTime
      property :updated_at, DateTime
      
    end
    
	class Player
      include DataMapper::Resource
	
	  property :id, Serial
	  property :playing, String
      property :updated_at, DateTime
	end


    DataMapper.finalize
    
    
    #
    # # Actions for the Daemon side
    #
    
    # Apparition du disc
    get '/app/:uid' do
		lp = LP.first( :UID => params[:uid])
	 
		if !lp.nil?
		 	play(lp.id)
		end
    end
    
	# Disparition du disc
    get '/dis/:uid' do
    	lp = LP.first( :UID => params[:uid])

   		if !lp.nil?
			stop(id)
		end
    end
    
    
    get '/' do
      "Default page"
    end
    
    #
    # # Actions for XBMC
    #
    get '/playing' do
      LP.all( :UID => Player.first.playing ).to_json( :only => [:UUID, :identifier])
    end
    
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
        "[{ 'success' : 'Album saved' }]"
      else
        lp.errors
      end
    end
    
    delete '/:id' do
      lp = LP.first( :identifier => params[:id] )
      
      if !lp.nil?
        lp.destroy
        "[{ 'success' : 'Album deleted' }]"
      else
        "[{ 'error' : 'Paire Doesn\'t exist' }]"
      end      
    end
    
    
    #
    # # misc functions
    #
    
    def play(id)
      pl = Player.first
	  pl.playing = id
	  pl.updated_at = Time.now
	  pl.save
    end
    
    def stop(id)
      pl = Player.first
	  pl.playing = ""
	  pl.updated_at = Time.now
	  pl.save
    end
    
    def toAdd(uid)
      
    end
      
