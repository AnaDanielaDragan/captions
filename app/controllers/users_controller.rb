# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authorize!

  def create
    attributes = params.require(:user).permit(:username, :password)

    user = User.create(attributes)
    token = user.tokens.create

    UserMailer.with(email: attributes[:username]).welcome_email.deliver_now

    render json: { token: token.value }, status: :created
  end

  def login
    attributes = params.require(:user).permit(:username, :password)

    user = User.find_by(username: attributes[:username])
    if user.password == attributes[:password]
      render json: { user: user }, status: :ok
    else
      render json: { error: 'Login failed!' }, status: :not_found
    end
  end
end
