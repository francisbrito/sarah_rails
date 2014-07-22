class RetrieveMailWorker
  include Sidekiq::Worker
  def perform(user_id, mail_qty = 5)
    #Step 1
    #Find the user
    #Step 2
    #Use the user g-token to retrieve latest email
    #Step 3
    #Call sarah_py POST to send a reply to the user with the emails subject and date
  end
end
