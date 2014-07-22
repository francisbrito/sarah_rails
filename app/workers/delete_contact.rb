class AddContactWorker
  include Sidekiq::Worker
  def perform(user_id, contact_id)
    #Step 1
    #Find the user
    #Step 2
    #Use the user g-token to delete the contact using the contacts api
    #Step 3
    #Call sarah_py POST to send a reply to the user indicating the contact was deleted
  end
end
