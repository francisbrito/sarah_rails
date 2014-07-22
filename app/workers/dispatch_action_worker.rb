require 'wit_ruby'

class DispatchActionWorker
  include Sidekiq::Worker
  def perform(msg_id)
    #Step 1
    #Find the message
    message = Message.find(msg_id)
    #Step 2
    #Find the user
    user = User.find(message.user_id)
    #Step 3
    #Dispatch an action depending on the message content
    #Step 3.1 - Call wit with the msg content
    client = Wit::REST::Client.new(token: "WNW4IBP7PBITS6KWZEIDCBQ7RM4BGEVH")
    session = client.session
    message_results = session.send_message(message.content)
    puts message_results.confidence # Returns the confidence of the message results at the specified index.
    puts message_results.entities # Returns the entities of the message results at the specified index.
    puts message_results.entity_names # Generates array of names of each entity in this message at the specified index.
    puts message_results.intent # Returns the intent that this message corresponded to at the specified index.

    #This next part is horrible but it was the simplest approach we could think of at the time
    case message_results.intent
    when 'Calendar_Appointment'
      AddEventWorker.perform_async(user_id=user.id, from_time=message_results.entities['datetime'][0].value.from, to_time=message_results.entities['datetime'][0].value.to, event_description=message_results.entities['agenda_entry'][0].value + ' with ' + message_results.entities['contact'][0].value)
    when 'calendar_appointment_edit'
      EditEventWorker.perform_async(user_id=user.id, from_time=message_results.entities['datetime'][0].value.from, to_time=message_results.entities['datetime'][0].value.to, event_description=message_results.entities['agenda_entry'][0].value + ' with ' + message_results.entities['contact'][0].value)
    when 'contact_add'
      name = message_results.entities['contact'][0].suggested ? message_results.entities['contact'][0].value : ''
      email = message_results.entities['email'][0].suggested ? message_results.entities['email'][0].value : ''
      phone = message_results.entities['phone'][0].suggested ? message_results.entities['phone'][0].value : ''
      AddContactWorker.perform_async(user_id=user.id, contact_name=name, contact_email=email, contact_phone=phone)
    when 'contact_delete'
      name = message_results.entities['contact'][0].suggested ? message_results.entities['contact'][0].value : ''
      email = message_results.entities['email'][0].suggested ? message_results.entities['email'][0].value : ''
      phone = message_results.entities['phone'][0].suggested ? message_results.entities['phone'][0].value : ''
      DeleteContactWorker.perform_async(user_id=user.id, contact_name=name, contact_email=email, contact_phone=phone)
    when 'retrieve_mail'
      mail_qty = message_results.entities['number'][0].suggested ? message_results.entities['number'][0].value : nil
      if(mail_qty)
        RetrieveMailWorker.perform_async(user_id=user.id, mail_qty=mail_qty)
      else
        RetrieveMailWorker.perform_async(user_id=user.id)
      end
    when 'send_mail'
      email = message_results.entities['email'][0].suggested ? message_results.entities['email'][0].value : ''
      subject = message_results.entities['message_subject'][0].suggested ? message_results.entities['message_subject'][0].value : ''
      content = message_results.entities['message_body'][0].suggested ? message_results.entities['message_body'][0].value : ''
      SendMailWorker.perform_async(user_id=user.id, email=email, subject=subject, content=content)
    else
      #Send the user a "i couldn't get what ya saying nigga"
    end
  end
end
