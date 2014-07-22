class EditEventWorker
  include Sidekiq::Worker
  def perform(user_id, event_description, from_time, to_time, is_recurrent)
    #Step 1
    #Find the user
    #Step 2
    #Validate input
    #Step 3
    #Use the user g-token to find the meeting using the event_description as query input
    #Step 4
    #Use the user g-token to edit the event using the calendar api
    #Step 5
    #Call sarah_py POST to send a reply to the user with all the meeting details
  end
end
