# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Images", type: :request do
  describe "GET /images/:id" do
    subject { get "/images/#{image_name}" }

    let(:image_name) { "#{SecureRandom.hex}.jpg" }

    it 'responds with 404' do
      subject

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
        post captions_path, params: caption_params

        expect(response).to have_http_status(:created)

        caption_url = JSON
                      .parse(response.body, symbolize_names: true)
                      .dig(:caption, :caption_url)

        get caption_url

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'image/jpeg'
        expect(response.body).not_to be_empty
      end
    end

    it 'responds with 200' do
      # To get the id:
      # - do some post before
      # - get it from somewhere else
      get "/images/#{image_name}"

      expect(response).to have_http_status(:ok)
    end

    it 'receives an image' do
      get "/images/#{image_name}"

      expect(response.body).not_to be_empty
      binding.pry
    end
  end
end
