class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
      @integrated_with_google = !session['devise.google'].nil? 

      # Retrieve all messages for current user.
      @messages = Message.where user_id: current_user.id
  end
end
