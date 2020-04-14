require 'sinatra'
# require 'sinatra/config_file'
require 'omniauth'
require 'omniauth-google-oauth2'
require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'
require './google_service'
# require 'figaro'
require 'dotenv'

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {scope: "userinfo.email, calendar"}
  provider OmniAuth::Strategies::GoogleOauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {scope: "userinfo.email, calendar"}
end

class Notifications < Sinatra::Application
  # register Sinatra::ConfigFile
  # config_file './config/application.yml'
  
  get '/' do
    'Hello World'
  end

  get '/calendar/info?' do
    GoogleService.get_calendars(params["token"],params["refresh_token"])
  end

  post '/calendar/new?' do
    calendar = GoogleService.create_new_calendar(params[:token],params[:refresh_token], params[:calendar_name])
    render json: calendar
  end

  post '/event/new?' do
    event_info = {
      token: params[:token],
      refresh_token: params[:refresh_token],
      calendar: params[:calendar],
      name: params[:name],
      description: params[:description],
      date: params[:date]
    }
    GoogleService.create_event(event_info)
  end

  get '/events/info?' do
    events = GoogleService.get_list_events(params[:token], params[:refresh_token], params[:calendar_name])
    render json: events
  end

end
