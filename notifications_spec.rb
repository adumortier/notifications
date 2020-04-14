ENV['APP_ENV'] = 'test'

require './notifications'
require 'rspec'
require 'rack/test'
require './config/environment'

RSpec.describe 'Notifications' do
  include Rack::Test::Methods

  def app
    Notifications
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end

  xit "can create a new calendar" do
    token = ENV['TEST_USER_GOOGLE_TOKEN']
    refresh_token = ENV['TEST_USER_GOOGLE_REFRESH_TOKEN']
    expect(GoogleService.get_calendars(token, refresh_token).include?('test_calendar')).to eq(false)
    post "/calendar/new?token=#{token}&refresh_token=#{refresh_token}&calendar_name=test_calendar"
    expect(GoogleService.get_calendars(token, refresh_token).include?('test_calendar')).to eq(true)
    calendars = GoogleService.get_calendars(token, refresh_token)
    GoogleService.delete_calendar(token, refresh_token, calendars['test_calendar'])
  end

  it "can create a new event" do
    token = ENV['TEST_USER_GOOGLE_TOKEN']
    refresh_token = ENV['TEST_USER_GOOGLE_REFRESH_TOKEN']
    calendar_id = GoogleService.get_calendars(token, refresh_token)["GardenThatApp"]
    events = GoogleService.get_list_events(token, refresh_token, calendar_id)
    expect(events.empty?).to eq(true)
    post "/event/new?token=#{token}&refresh_token=#{refresh_token}&calendar=GardenThatApp&name=test_event&description=an_event_description&date=2020-05-23"
    events = GoogleService.get_list_events(token, refresh_token, calendar_id)
    expect(events.length).to eq(1)
    expect(events[0].name).to eq('test_event')
    expect(events[0].description).to eq('an_event_description')
    expect(events[0].start[0..9]).to eq('2020-05-23')
    expect(events[0].end[0..9]).to eq('2020-05-23')
    GoogleService.delete_event(token, refresh_token, calendar_id, events[0].id)
  end



end