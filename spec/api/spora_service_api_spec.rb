require 'spec_helper'
require 'pry'

describe SporaServiceApi::API do
  include Rack::Test::Methods

  def app
    SporaServiceApi::API
  end

  describe 'General' do

    it 'responds to ping' do
      get '/api/v1/ping'
      last_response.status.should == 200
      last_response.body.include?('pong')
    end

  end
end