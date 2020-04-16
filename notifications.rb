require 'sinatra'
require 'omniauth'
require 'omniauth-google-oauth2'
require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'
require './google_service'
require 'sinatra/json'
require 'dotenv'

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {scope: "userinfo.email, calendar"}
  provider OmniAuth::Strategies::GoogleOauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {scope: "userinfo.email, calendar"}
end

class Notifications < Sinatra::Application
  
  get '/' do
    'Hello World'
  end

  get '/calendar/info?' do
    calendars_info = GoogleService.get_calendars(params["token"],params["refresh_token"])
    json calendars_info
  end

  post '/calendar/new?' do
    calendar = GoogleService.create_new_calendar(params[:token],params[:refresh_token], params[:calendar_name])
    json calendar
  end

  post '/event/new?' do
    event_info = GoogleService.create_event(token: params[:token],
                                            refresh_token: params[:refresh_token],
                                            calendar_id: params[:calendar_id],
                                            name: params[:name],
                                            description: params[:description],
                                            date: params[:date])
    json event_info
  end

  get '/events/info?' do
    calendar_id = GoogleService.get_calendars(params[:token], params[:refresh_token])[params[:calendar_name]]
    events = GoogleService.get_list_events(params[:token], params[:refresh_token], calendar_id)
    events_info = events.map do |event|
      event.info
    end
    json events_info
  end

  delete '/event/info?' do
    GoogleService.delete_event(params[:token], params[:refresh_token], params[:calendar_id], params[:event_id])
    json event
  end


end
