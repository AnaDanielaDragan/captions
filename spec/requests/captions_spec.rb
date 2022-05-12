# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Captions', type: :request do
  describe 'GET /captions' do
    it 'responds with 200' do
      get captions_path
      expect(response).to have_http_status(:ok)
    end

    it 'responds with correct body' do
      get captions_path

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response).to eq({ captions: [] })
    end

    context 'with existent caption' do
      let(:url) { Faker::LoremFlickr.image }
      let(:text) { Faker::TvShows::GameOfThrones.quote }
      let(:image_name) { Digest::MD5.hexdigest "#{url}, #{text}" }
      let(:params) do
        {
          caption: {
            url: url,
            text: text
          }
        }
      end

      before { post captions_path, params: params }

      it 'responds with 200' do
        get captions_path

        expect(response).to have_http_status(:ok)
      end

      it 'responds with correct body' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        id = json_response[:caption][:id]

        get captions_path

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:captions]).to include(hash_including({
                                                                     id: id,
                                                                     url: url
                                                                   }))
      end
    end
  end

  describe 'POST /captions' do
    let(:url) { Faker::LoremFlickr.image }
    let(:text) { Faker::TvShows::GameOfThrones.quote }
    let(:image_name) { Digest::MD5.hexdigest "#{url}, #{text}" }

    let(:params) do
      {
        caption: {
          url: url,
          text: text
        }
      }
    end

    it 'responds with 201' do
      post captions_path, params: params
      expect(response).to have_http_status(:created)
    end

    it 'responds with correct body' do
      post captions_path, params: params

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:caption]).to match(hash_including({
                                                                url: url,
                                                                text: text,
                                                                caption_url: "/images/#{image_name}.jpg"
                                                              }))
    end

    context 'with invalid body' do
      let(:url) { Faker::LoremFlickr.image }
      let(:text) { Faker::TvShows::GameOfThrones.quote }
      let(:image_name) { Digest::MD5.hexdigest "#{url}, #{text}" }
      let(:params) do
        {
          caption: {
            uri: url,
            cats: text
          }
        }
      end

      it 'responds with 400' do
        post captions_path, params: params

        expect(response).to have_http_status(:bad_request)

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response).to match(BadRequestError.body)
      end
    end

    context 'with invalid params' do
      let(:url) { SecureRandom.hex }
      let(:text) { nil }
      let(:image_name) { Digest::MD5.hexdigest "#{url}, #{text}" }
      let(:params) do
        {
          caption: {
            url: url,
            text: text
          }
        }
      end

      it 'responds with 422' do
        post captions_path, params: params

        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response).to match(MissingParametersError.body)
      end
    end
  end

  describe 'GET /captions/:id' do
    let(:url) { Faker::LoremFlickr.image }
    let(:text) { Faker::TvShows::GameOfThrones.quote }
    let(:image_name) { Digest::MD5.hexdigest "#{url}, #{text}" }
    let(:params) do
      {
        caption: {
          url: url,
          text: text
        }
      }
    end

    before { post captions_path, params: params }

    it 'responds with 200' do
      json_response = JSON.parse(response.body, symbolize_names: true)
      id = json_response[:caption][:id]

      get caption_path(id)

      expect(response).to have_http_status(:ok)
    end

    it 'responds with correct body' do
      json_response = JSON.parse(response.body, symbolize_names: true)
      id = json_response[:caption][:id]

      get caption_path(id)

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:caption]).to match(hash_including({
                                                                url: url,
                                                                text: text,
                                                                caption_url: "/images/#{image_name}.jpg"
                                                              }))
    end

    context 'when requesting an inexistent resource' do
      it 'responds with 404' do
        get caption_path('foo')

        expect(response).to have_http_status(:not_found)

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response).to match(NotFoundError.body)
      end
    end
  end

  describe 'DELETE /captions/:id' do
    let(:url) { Faker::LoremFlickr.image }
    let(:text) { Faker::TvShows::GameOfThrones.quote }
    let(:params) do
      {
        caption: {
          url: url,
          text: text
        }
      }
    end

    it 'responds with 200' do
      post captions_path, params: params

      json_response = JSON.parse(response.body, symbolize_names: true)

      id = json_response[:caption][:id]

      delete caption_path(id)
      expect(response).to have_http_status(:ok)
    end
  end
end
