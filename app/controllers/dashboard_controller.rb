class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
      @integrated_with_google = session['devise.google'].nil? 
  end
end
