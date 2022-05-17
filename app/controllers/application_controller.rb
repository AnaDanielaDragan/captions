# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authorize!

  def authorize!
    token = request.headers['X-Token']

    head :unauthorized unless Token.by_value(token).exists?
  end
end
