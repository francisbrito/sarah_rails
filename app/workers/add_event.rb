class AddEventWorker
  include Sidekiq::Worker
  def perform(user_id, event_description, from_time, to_time, is_recurrent)
    #Step 1
    #Find the user
    #Step 2
    #Validate input
    #Step 3
    #Use the user g-token to create the event using the calendar api
    #Step 4
    #Call sarah_py POST to send a reply to the user indicating the meeting time
  end
end
