class DispatchActionWorker
  include Sidekiq::Worker
  def perform(msg_id)
    #Step 1
    #Find the message
    #Step 2
    #Find the user
    #Step 3
    #Dispatch an action depending on the message content
  end
end
