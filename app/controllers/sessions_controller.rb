class SessionsController < ApplicationController
    def create
    end

    protected

    def auth_params
        request.env['omniauth.auth']
    end
end
