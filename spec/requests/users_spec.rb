require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /signup" do
    subject(:signup) { post '/signup', params: params }

    let(:params) do
      {
        user: {
          username: 'foo@bar.com',
          password: 'foo1234'
        }
      }
    end

    it 'responds with created' do
      signup

      expect(response).to have_http_status(:created)
    end

    it 'creates a user' do
      expect {
        signup
      }.to change { User.count }.by(1)
    end

    it 'creates a token' do
      expect {
        signup
      }.to change { Token.count }.by(1)

      token = Token.last
      expect(token.value).not_to be_blank
      expect(token.expires_at).to be_within(1.second).of(1.day.from_now)
    end

    it 'responds with correct body' do
      signup

      token = Token.last

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:token]).to eq token.value
    end
  end

  describe "POST /login" do
    let(:params) do
      {
        user: {
          username: 'foo@bar.com',
          password: 'foo1234'
        }
      }
    end

    before { post '/signup', params: params }

    it 'responds with ok' do
      post '/login', params: params

      expect(response).to have_http_status(:ok)
    end

    it 'responds with correct body' do
      post '/login', params: params

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:user]).not_to be_empty
    end
  end
end
