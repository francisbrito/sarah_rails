class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
        # TODO: Save Google token.
        current_user.update_from_google_oauth_hash(request.env['omniauth.auth'])

        session['devise.google'] = request.env['omniauth.auth']

        redirect_to dashboard_index_path
    end

    def facebook
        # TODO: Save Facebook token.
    end

    def twitter
        # TODO: Save Twitter token.
    end

    def github
        # TODO: Save Github token.
    end
end
