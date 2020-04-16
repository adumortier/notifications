require 'sinatra/base'
require './event'

class GoogleService < Sinatra::Base

  def self.get_calendars(token, refresh_token)
    service = refresh_authorization(token, refresh_token)
    calendar_list = service.list_calendar_lists.items
    calendars_info = calendar_list.reduce({}) do |acc,calendar|
      acc[calendar.summary] = calendar.id
      acc
    end
    return calendars_info
  end

  def self.create_new_calendar(token, refresh_token, name)
    service = refresh_authorization(token, refresh_token)
    calendar = Google::Apis::CalendarV3::Calendar.new(summary: name)
    result = service.insert_calendar(calendar)
    return {name: result.summary, id: result.id}
  end

  def self.delete_calendar(token, refresh_token, name)
    service = refresh_authorization(token, refresh_token)
    service.delete_calendar(name)
  end

  def self.delete_event(token, refresh_token, calendar_id, event_id)
    service = refresh_authorization(token, refresh_token)
    service.delete_calendar(calendar_id, event_id)
  end

  def self.create_event(info)
    service = refresh_authorization(info[:token], info[:refresh_token])
    event = Google::Apis::CalendarV3::Event.new(
      summary: info[:name],
      description: info[:description],
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: info[:date] + 'T09:00:00-07:00',
        time_zone: 'America/Los_Angeles'
        ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: info[:date] + 'T17:00:00-07:00',
        time_zone: 'America/Los_Angeles'
        )
      )
    result = service.insert_event(info[:calendar_id], event)
    return {summary: result.summary, description: result.description, id: result.id}
  end

  def self.delete_event(token, refresh_token, calendar_id, event_id)
     service = refresh_authorization(token, refresh_token)
     result = service.delete_event(calendar_id, event_id)
  end

  def self.get_list_events(token, refresh_token, calendar_id)
    calendars_info = get_calendars(token, refresh_token)
    now = Time.now.iso8601
    service = refresh_authorization(token, refresh_token)
    items = service.fetch_all do |token|
      service.list_events(calendar_id, single_events: true, order_by: 'startTime', time_min: now, page_token: token)
    end
    events = items.map do |item|
      Event.new(name: item.summary, start: item.start, end: item.end, description: item.description, id: item.id)
    end
    return events
  end

  private

  def self.refresh_authorization(google_token, google_refresh_token)
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = google_secret(google_token, google_refresh_token).to_authorization
    service.authorization.refresh!
    return service
  end

  def self.google_secret(google_token, google_refresh_token)
    Google::APIClient::ClientSecrets.new(
      { "web" =>
        { "access_token" => google_token,
          "refresh_token" => google_refresh_token,
          "client_id" =>ENV['GOOGLE_CLIENT_ID'],
          "client_secret" => ENV['GOOGLE_CLIENT_SECRET'],
        }
      }
    )
  end
end