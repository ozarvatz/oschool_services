require 'spec_helper'
require 'pry'
require 'json'

describe SporaServiceApi::API do
	include Rack::Test::Methods

	def app
		SporaServiceApi::API
	end

	describe 'Tags' do
		before do
			put '/api/v1/tag/aaa', { users: [1, 2 ,3], flags: { mqp: true, dqp: false} }
			put '/api/v1/tag/bbb', { users: [1, 2 ,3, 4], flags: { mqp: true, dqp: false} }
			put '/api/v1/tag/ccc', { users: [1, 2 ,3, 5], flags: { mqp: true, dqp: false} }
			put '/api/v1/tag/ddd', { users: [1, 2 ,3, 6], flags: { mqp: true, dqp: false} }
		end
		
		after do
			delete '/api/v1/tag/aaa'
			delete '/api/v1/tag/bbb'
			delete '/api/v1/tag/ccc'
			delete '/api/v1/tag/ddd'
		end

		it 'all tags length sould be >= 4' do
		  	get '/api/v1/tag/'
		  	data = JSON.parse(last_response.body)
		  	data["all"].length.should >= 4 
		  	last_response.status.should == 200
		end

		it "should return tag's fields" do
			get '/api/v1/tag/ddd'
			data = JSON.parse(last_response.body)
			data["doc"]["users"][3].should == "6"
			data["doc"]["flags"]["mqp"].should == "true"
			last_response.status.should == 200
		end

		it "should return tag's users" do
			get '/api/v1/tag/ddd/users'
			data = JSON.parse(last_response.body)
			data["doc"]["users"][3].should == "6"
			data["doc"]["flags"].should == nil
			last_response.status.should == 200
		end

		it "should return tag's flags" do
			get '/api/v1/tag/ddd/flags'
			data = JSON.parse(last_response.body)
			data["doc"]["flags"]["mqp"].should == "true"
			data["doc"]["users"].should == nil
			last_response.status.should == 200
		end
		

		it "push to users array '777', the array length should be 5 and the last string should be '777'" do 
			put '/api/v1/tag/ccc/push', { users: 777 }
			last_response.status.should == 200
			get '/api/v1/tag/ccc/users'
			data = JSON.parse(last_response.body)
			data["doc"]["users"].length.should == 5
			data["doc"]["users"][-1].should eq '777'
		end

		it "create tag name moshe and then delete it" do
			put '/api/v1/tag/moshe', { users: [1, 2 ,3], flags: { mqp: true, dqp: false} }
			last_response.status.should == 200

			get '/api/v1/tag/moshe'
			data = JSON.parse(last_response.body)
			data["doc"]["users"][2].should == "3"
			data["doc"]["flags"]["mqp"].should == "true"
			last_response.status.should == 200

			delete '/api/v1/tag/moshe'
			last_response.status.should == 200

			get '/api/v1/tag/moshe'
			last_response.status.should == 200
			data = JSON.parse(last_response.body)
			data["doc"].should == nil
		end
		
	end
end