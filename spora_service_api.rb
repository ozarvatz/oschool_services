require 'rubygems'
require 'sinatra'
require 'grape'
require 'authlogic'
require 'pry'
require 'mongoid'
require 'logger'
require './config/configuration.rb'
Configuration.init
require './lib/base_mongoid.rb'
require './models/tags.rb'
require './api/tags_api.rb'
require './models/users.rb'
require './api/users_api.rb'


module SporaServiceApi
	class API < Grape::API

		include Authlogic::ControllerAdapters::SinatraAdapter::Adapter::Implementation

		prefix 'api'
		version 'v1'
		format :json

		rescue_from :all do |e|
			$log.error "Execption: #{e.message}, trace: #{e.backtrace}"
			Rack::Response.new({status: 500, message: e.inspect, backtrace: e.backtrace}.to_json, 500)
		end	

		helpers do
	  		# response is being called by Authlogic, which doesn't seem
	  		# to return anything when using Grape.
	  		def response
	  			Rack::Response.new
	  		end
	  	end
	  	
		get 'ping' do
			content_type 'text/plain'
		  	"pong"
		end

		group(:tag) { mount SporaServiceApi::TagsApi }
		group(:user) { mount SporaServiceApi::UsersApi }

		puts "Listening..."
	end
end