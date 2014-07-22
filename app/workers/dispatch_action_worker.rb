require 'wit_ruby'
require_relative '../../lib/actions/add_event_action'

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
      params = {}
      message_results.entities.each do | key, value |
        if !message_results.entities[key][0]['suggested'].nil?
          params[key] = message_results.entities[key][0]['suggested'] ? message_results.entities[key][0]['value'] : ''
        else
          params[key] = message_results.entities[key][0]['value']
        end
      end

      addEventAction = AddEventAction.new()
      addEventAction.create_event(user_id=user.id, event_description=params['agenda_entry'], from_time=params['datetime']['from'], to_time=params['datetime']['to'], recurrent_freq=nil)
    # when 'calendar_appointment_edit'
    #   params = {}
    #   message_results.entities.each do | key, value |
    #     if !message_results.entities[key][0]['suggested'].nil?
    #       params[key] = message_results.entities[key][0]['suggested'] ? message_results.entities[key][0]['value'] : ''
    #     else
    #       params[key] = message_results.entities[key][0]['value']
    #     end
    #   end
    #   EditEventWorker.perform_async(user_id=user.id, from_time=params['datetime']['from'], to_time=params['datetime']['to'], event_description=params['agenda_entry'])
    # when 'contact_add'
    #   #require 'pry'; binding.pry
    #   params = {}
    #   message_results.entities.each do | key, value |
    #     if !message_results.entities[key][0]['suggested'].nil?
    #       params[key] = message_results.entities[key][0]['suggested'] ? message_results.entities[key][0]['value'] : ''
    #     else
    #       params[key] = message_results.entities[key][0]['value']
    #     end
    #   end
    #   AddContactWorker.perform_async(user_id=user.id, contact_name=params['contact'], contact_email=params['email'], contact_phone=params['phone_number'])
    # when 'contact_delete'
    #   name = message_results.entities['contact'][0].suggested ? message_results.entities['contact'][0].value : ''
    #   email = message_results.entities['email'][0].suggested ? message_results.entities['email'][0].value : ''
    #   phone = message_results.entities['phone'][0].suggested ? message_results.entities['phone'][0].value : ''
    #   DeleteContactWorker.perform_async(user_id=user.id, contact_name=name, contact_email=email, contact_phone=phone)
    # when 'retrieve_mail'
    #   mail_qty = message_results.entities['number'][0].suggested ? message_results.entities['number'][0].value : nil
    #   if(mail_qty)
    #     RetrieveMailWorker.perform_async(user_id=user.id, mail_qty=mail_qty)
    #   else
    #     RetrieveMailWorker.perform_async(user_id=user.id)
    #   end
    # when 'send_mail'
    #   email = message_results.entities['email'][0].suggested ? message_results.entities['email'][0].value : ''
    #   subject = message_results.entities['message_subject'][0].suggested ? message_results.entities['message_subject'][0].value : ''
    #   content = message_results.entities['message_body'][0].suggested ? message_results.entities['message_body'][0].value : ''
    #   SendMailWorker.perform_async(user_id=user.id, email=email, subject=subject, content=content)
    else
      #Send the user a "i couldn't get what ya saying nigga"
    end
  end
end
