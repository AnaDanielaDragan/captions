# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome_email
    email = params[:email]

    mail(to: email, subject: 'Welcome!')
  end
end
