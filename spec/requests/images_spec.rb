# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Images", type: :request do
  describe "GET /images/:id" do
    subject(:get_images) { get "/images/#{image_name}", headers: auth_headers }

    let(:image_name) { "#{SecureRandom.hex}.jpg" }

    it 'responds with 404' do
      get_images

      expect(response.status).to eq 404
    end

    context 'when a caption is created' do
      let(:caption_params) do
        {
          caption: {
            url: Faker::LoremFlickr.image,
            text: 'Ana are mere!'
          }
        }
      end

      it 'responds with the image' do
        post captions_path, headers: auth_headers, params: caption_params

        expect(response).to have_http_status(:accepted)

        caption_url = JSON
                      .parse(response.body, symbolize_names: true)
                      .dig(:caption, :caption_url)

        get caption_url, headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'image/jpeg'

        # TODO: Add image content to response body
        # expect(response.body).not_to be_empty
      end
    end
  end
end
