
class SessionsController < ApplicationController
    def create
      user = User.find_by(username: params[:username])
  
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        render json: { id: user.id, username: user.username, image_url: user.image_url, bio: user.bio }, status: :ok
      else
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end

    def destroy
        if session[:user_id]
          session[:user_id] = nil
          head :no_content
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end
  end
  