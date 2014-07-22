class SendMailWorker
  include Sidekiq::Worker
  def perform(user_id, email, subject, content)
    #Step 1
    #Find the user
    #Step 2
    #Validate input
    #Step 3
    #Use the user g-token to send the mail
    #Step 4
    #Call sarah_py POST to send a reply to the user
  end
end
