require_relative '../../lib/baseworker.rb'

class AddEventWorker
  include Sidekiq::Worker
  
  def perform(user_id, event_description, from_time, to_time, recurrent_freq )
    
    #Step 1
    #Find the user

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

    @call = {
          :api_method => @calendar.events.insert,
          :parameters => {'calendarId' =>  user_id.email}, #'lowell.abbott@gmail.com'
          :body => MultiJson.dump(event1),
          :headers => {'Content-Type' => 'application/json'}
        }
    
   
=begin
    result = client.execute(:api_method => service.events.insert,
                        :parameters => {'calendarId' => 'primary'},
                        :body => JSON.dump(event),
                        :headers => {'Content-Type' => 'application/json'})
    print result.data.id
=end

    #Step 2
    #Validate input
    
    #Step 3
    #Use the user g-token to create the event using the calendar api
    
    batch = Google::APIClient::BatchRequest.new { |result| }
    batch.add(@call, '1')
    request = batch.to_env(CLIENT.connection)
    boundary = Google::APIClient::BatchRequest::BATCH_BOUNDARY
    request[:method].to_s.downcase.should == 'post'
    request[:url].to_s.should == 'https://www.googleapis.com/batch'
    request[:request_headers]['Content-Type'].should == "multipart/mixed;boundary=#{boundary}"


    #Step 4
    #Call sarah_py POST to send a reply to the user indicating the meeting time
    
    resp = Response.new()
    resp.send_response('18298647935','Sup, this works') 

  end