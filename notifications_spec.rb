ENV['APP_ENV'] = 'test'

require './notifications'
require 'rspec'
require 'rack/test'

RSpec.describe 'Notifications' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end
end