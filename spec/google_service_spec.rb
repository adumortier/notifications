ENV['APP_ENV'] = 'test'

require './notifications'
require 'rspec'
require 'rack/test'

RSpec.describe 'Notifications' do
  include Rack::Test::Methods

  def app
    Notifications
  end

  before(:each) do
    @token = ENV['TEST_USER_GOOGLE_TOKEN']
    @refresh_token = ENV['TEST_USER_GOOGLE_REFRESH_TOKEN']
    @calendar_id = GoogleService.get_calendars(@token, @refresh_token)["GardenThatApp"]
  end

  it "can return calendar information" do
    list_calendars = ["gardenthat@gmail.com", "GardenThatApp"]
    expect(GoogleService.get_calendars(@token, @refresh_token).keys.to_set).to eq(list_calendars.to_set)
  end

  it "can create a new calendar" do
    expect(GoogleService.get_calendars(@token, @refresh_token).include?('test_calendar')).to eq(false)
    result = GoogleService.create_new_calendar(@token, @refresh_token, 'test_calendar')
    expect(GoogleService.get_calendars(@token, @refresh_token).include?('test_calendar')).to eq(true)
    GoogleService.delete_calendar(@token, @refresh_token, result[:id])
  end

  it "can create a new event in the calendar" do
    event_info = {
      token: @token,
      refresh_token: @refresh_token,
      calendar_id: @calendar_id,
      name: 'Tomato time!!',
      description: "it's about time you harvest those tomatoes",
      date: '2020-05-28'
    }
    result = GoogleService.create_event(event_info)
    events = GoogleService.get_list_events(@token, @refresh_token, @calendar_id)
    expect(events.length).to eq(1)
    expect(events[0].name).to eq('Tomato time!!')
    expect(events[0].description).to eq("it's about time you harvest those tomatoes")
    GoogleService.delete_event(@token, @refresh_token, @calendar_id, result[:id])
  end

  it "can get return a list of events for a calendar" do
    event1_info = {
      token: @token,
      refresh_token: @refresh_token,
      calendar_id: @calendar_id,
      name: 'Tomato time!!',
      description: "it's about time you harvest those tomatoes",
      date: '2020-05-28'
    }
    event1 = GoogleService.create_event(event1_info)
    event2_info = {
      token: @token,
      refresh_token: @refresh_token,
      calendar_id: @calendar_id,
      name: 'Mint time!!',
      description: "Your mint will be just right in about 10 days",
      date: '2020-06-05'
    }
    event2 = GoogleService.create_event(event2_info)
    events = GoogleService.get_list_events(@token, @refresh_token, @calendar_id)

    expect(events.length).to eq(2)
    expect(events[0].name).to eq(event1_info[:name]) 
    expect(events[1].name).to eq(event2_info[:name])

    GoogleService.delete_event(@token, @refresh_token, @calendar_id, event1[:id])
    GoogleService.delete_event(@token, @refresh_token, @calendar_id, event2[:id])
  end




end