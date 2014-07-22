require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require_relative '../../lib/baseworker.rb'

class AddContactWorker
  include Sidekiq::Worker
  def perform(user_id, contact_name, contact_email, contact_phone)
    #Step 1
    #Find the user
    user = User.find(user_id)
    #Step 2
    #Use the user g-token to add the contact using the contacts api
    client = Google::APIClient.new
    client.authorization.access_token = user.oauth_google

    if client.authorization.refresh_token && client.authorization.expired?
      client.authorization.fetch_access_token!
    end

    service = client.discovered_api('contacts', 'v3')

    new_contact = {
          'name' => contact_name,
          'email' => [contact_email],
          'phone_number' => [contact_phone]
        }

    result = client.execute(:api_method => service.events.insert,
                            :body => JSON.dump(new_contact),
                            :headers => {'Content-Type' => 'application/json'})
    print result.data
    #Step 3
    #Call sarah_py POST to send a reply to the user indicating the contact was added
    resp = Response.new()
    resp.send_response(user.phone, 'Contact added') 
  end
end
