require 'rails_helper'

RSpec.describe 'InstagramCaptions', type: :request do
  describe 'POST /captions/instagram' do
    let(:url) { Faker::LoremFlickr.image }
    let(:text) { Faker::TvShows::GameOfThrones.quote }
    let(:image_name) { Digest::MD5.hexdigest "#{url}, #{text}" }
    let(:params) do
      {
        image: {
          content_type: "image",
          url: url,
          text: text
        }
      }
    end

    it 'responds with 201' do
      post instagram_captions_path, params: params
      expect(response).to have_http_status(:created)
    end

    it 'responds with correct body' do
      post instagram_captions_path, params: params

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:caption]).to match(hash_including({
                                                                content_type: "image",
                                                                url: url,
                                                                text: text # ,
                                                                # caption_url: "/images/#{image_name}.jpg"
                                                              }))
    end

  end
end
