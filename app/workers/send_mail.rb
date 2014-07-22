require_relative '../../lib/baseworker.rb'
require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require "base64"

class SendMailWorker
  include Sidekiq::Worker

  def perform(user_id, email, subject, content)
    #Step 1
    #Find the user


    client = Google::APIClient.new(
      :application_name => 'Sarah',
      :application_version => '1.0.0'
    )

    enc   = Base64.encode64(content)
    plain = Base64.decode64(enc)

    # Initialize Google+ API. Note this will make a request to the
    # discovery service every time, so be sure to use serialization
    # in your production code. Check the samples for more details.
    # Make an API call.

    result = client.execute(
      :api_method => gmail.users.messages.send,
      :parameters => {'userId' => 'me','raw' => ec}
    )
 
    #Step 2
    #Validate input
    #Step 3
    #Use the user g-token to send the mail
    #Step 4
    #Call sarah_py POST to send a reply to the user
    resp = Response.new()
    resp.send_response(user_id.phone_number,'email sended ') 
  end
end
