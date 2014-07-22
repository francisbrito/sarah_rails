require 'rubygems'
require 'google/api_client'
#require_relative '../../lib/baseworker.rb'

=begin
More info of how create events:

https://developers.google.com/google-apps/calendar/recurringevents

=end

class AddEventAction

  def create_event(user_id, event_description, from_time, to_time, recurrent_freq)

    #Step 1
    #Find the user
    user = User.find user_id

    #Step 2
    #Validate input
    client = Google::APIClient.new
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

    #Step 3
    #Use the user g-token to create the event using the calendar api
    result = client.execute(:api_method => service.events.insert,
                            :parameters => {'calendarId' => 'primary'},
                            :body => JSON.dump(event),
                            :headers => {'Content-Type' => 'application/json'})
    #require 'pry'; binding.pry
    #print result

    #Step 4
    #Call sarah_py POST to send a reply to the user indicating the meeting time
    uri = URI.parse("http://192.168.43.208:5000/message")

    header = {'Content-Type'=> 'application/json'}
    params =  {
                'msg'=> 'Created the event',
                'number'=> user.phone_number
              }
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = params.to_json
    response = http.request(request)
  end
end
