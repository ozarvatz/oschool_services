require 'spec_helper'
require 'pry'
require 'json'

describe SporaServiceApi::API do
	include Rack::Test::Methods

	def app
		SporaServiceApi::API
	end

	describe 'User' do
		before do
			put '/api/v1/user/11', { type: 'sender', search_strings: ['string 1','string 2'], tags: { ddd: false, ccc: true }}
			put '/api/v1/user/12', { type: 'sender', search_strings: ['string 1','string 2'], tags: { ddd: false, ccc: true }}
			put '/api/v1/user/13', { type: 'sender', search_strings: ['string 1','string 2'], tags: { ddd: false, ccc: true }}
			put '/api/v1/user/14', { type: 'sender', search_strings: ['string 1','string 2'], tags: { ddd: false, ccc: true }}
		end
		it 'add new' do
		  	put '/api/v1/user/1', { type: 'sender', search_strings: ['string 1','string 2'], tags: { ddd: false, ccc: true }}
		  	last_response.status.should == 200
		end

		it 'retrive by id' do
			get '/api/v1/user/11'
			last_response.status.should == 200
		end

		it 'update email' do 
			put '/api/v1/user/11', { email: 'xxx@xxx.com'}
			get '/api/v1/user/11'
			data = JSON.parse(last_response.body)
			last_response.status.should == 200
			data["user"]["email"].should == "xxx@xxx.com"
		end

		it 'delete by id' do 
			delete '/api/v1/user/1'
			last_response.status.should == 200
		end

		it "pop serch array first value, the array left with one string 'string 2'" do 
			post '/api/v1/user/11/pop', { array_name: 'search_strings', pop_option: -1 }
			last_response.status.should == 201
			get '/api/v1/user/11'
			data = JSON.parse(last_response.body)
			data["user"]["search_strings"].length.should == 1
			data["user"]["search_strings"][0].should eq 'string 2'
		end

		it "push to serch array 'string 3', the array length should be 3 and the last string should be 'string 3'" do 
			put '/api/v1/user/12/push', { search_strings: 'string 3' }
			last_response.status.should == 200
			get '/api/v1/user/12'
			data = JSON.parse(last_response.body)
			data["user"]["search_strings"].length.should == 3
			data["user"]["search_strings"][-1].should eq 'string 3'
		end

		after do
			delete '/api/v1/user/1'
			delete '/api/v1/user/11'
			delete '/api/v1/user/12'
			delete '/api/v1/user/13'
			delete '/api/v1/user/14'
		end
	end
end