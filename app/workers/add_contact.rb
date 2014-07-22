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
    #client = GData::Client::DocList.new
    #Step 3
    #Call sarah_py POST to send a reply to the user indicating the contact was added
    resp = Response.new()
    resp.send_response(user.phone, 'Contact added')
  end
end
