require 'rubygems'
require 'google/api_client'
require_relative '../../lib/baseworker.rb'

=begin
More info of how create events:

https://developers.google.com/google-apps/calendar/recurringevents

=end

class AddEventWorker
  include Sidekiq::Worker

  def perform(user_id, event_description, from_time, to_time, recurrent_freq )

    #Step 1
    #Find the user

    user = User.find user_id

    client = Google::APIClient.new
    # client.authorization.client_id = oauth_yaml["client_id"]
    # client.authorization.client_secret = oauth_yaml["client_secret"]
    # client.authorization.scope = oauth_yaml["scope"]
    # client.authorization.refresh_token = oauth_yaml["refresh_token"]
    client.authorization.access_token = user.oauth_google

    if client.authorization.refresh_token && client.authorization.expired?
      client.authorization.fetch_access_token!
    end

    service = client.discovered_api('calendar', 'v3')

    if recurrent_freq
      event = {
            'summary' => event_description,
            'location' => 'Somewhere',
            'start' => {
              'dateTime' => from_time
            },
            'end' => {
              'dateTime' => to_time
            },
            'recurrence' => ['RRULE:FREQ=' + recurrent_freq]
          }
    else
        event = {
          'summary' => event_description,
          'location' => 'Somewhere',
          'start' => {
            'dateTime' => from_time
          },
          'end' => {
            'dateTime' => to_time
          },
        }
    end

result = client.execute(:api_method => service.events.insert,
                        :parameters => {'calendarId' => 'primary'},
                        :body => JSON.dump(event),
                        :headers => {'Content-Type' => 'application/json'})
print result.data.id


    #Step 2
    #Validate input

    #Step 3
    #Use the user g-token to create the event using the calendar api

    #Step 4
    #Call sarah_py POST to send a reply to the user indicating the meeting time

    resp = Response.new()
    resp.send_response('18298647935','Sup, this works')

  end
end
