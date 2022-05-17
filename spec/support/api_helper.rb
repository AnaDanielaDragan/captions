# frozen_string_literal: true

module ApiHelper
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def authenticate_request!
    params = {
      user: {
        username: "foo@bar.com",
        password: "foo123"
      }
    }
    post "/signup", params: params

    expect(response).to have_http_status :created
  end

  def auth_headers
    authenticate_request!
    { 'X-Token' => json_response[:token] }
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :request
end
