require 'sinatra'
require 'sinatra/config_file'
require 'omniauth'
require 'omniauth-google-oauth2'
require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {scope: "userinfo.email, calendar"}
  provider OmniAuth::Strategies::GoogleOauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {scope: "userinfo.email, calendar"}
end


class Notifications < Sinatra::Application
  register Sinatra::ConfigFile
  config_file './config/application.yml'
  
  get '/' do
    'Hello World'
  end

  post '/auth/:provider/callback' do
    auth = request.env['omniauth.auth']
    require 'pry'; binding.pry
  end
end
