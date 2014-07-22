class Users::RegistrationsController < Devise::RegistrationsController
   def create
        @user = User.create user_registration_params

        if @user.save
            sign_in :user, @user
            redirect_to dashboard_index_path
        end
   end 

   def user_registration_params
       params.require(:user).permit(:phone_number, :email, :password, :password_confirmation)
   end
end
