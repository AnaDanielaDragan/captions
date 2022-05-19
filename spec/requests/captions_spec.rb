# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Captions', type: :request do
  describe 'GET /captions' do
    subject(:get_captions) { get captions_path, headers: auth_headers }

    it 'responds with 200' do
      get_captions

      expect(response).to have_http_status(:ok)
    end

    it 'responds with correct body' do
      get_captions

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

      before { post captions_path, headers: auth_headers, params: params }

      it 'responds with 200' do
        get_captions

        expect(response).to have_http_status(:ok)
      end

      it 'responds with correct body' do
        id = json_response[:caption][:id]

        get_captions

        expect(json_response[:captions]).to include(hash_including({
                                                                     id: id,
                                                                     url: url
                                                                   }))
      end
    end

    context 'without authorization' do
      it 'responds with 401' do
        get captions_path

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with expired token' do
      it 'responds with 401' do
        headers = Timecop.freeze(2.days.ago) { auth_headers }

        get captions_path, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /captions' do
    subject(:post_captions) { post captions_path, headers: auth_headers, params: params }

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
      post_captions

      expect(response).to have_http_status(:accepted)
    end

    it 'responds with correct body' do
      post_captions

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
        post_captions

        expect(response).to have_http_status(:bad_request)

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
        post_captions

        expect(response).to have_http_status(:unprocessable_entity)

        expect(json_response).to match(MissingParametersError.body)
      end
    end

    context 'without authorization' do
      it 'responds with 401' do
        post captions_path, params: params

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with expired token' do
      it 'responds with 401' do
        headers = Timecop.freeze(2.days.ago) { auth_headers }

        post captions_path, headers: headers, params: params

        expect(response).to have_http_status(:unauthorized)
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

    before { post captions_path, headers: auth_headers, params: params }

    it 'responds with 200' do
      id = json_response[:caption][:id]

      get caption_path(id), headers: auth_headers

      expect(response).to have_http_status(:ok)
    end

    it 'responds with correct body' do
      id = json_response[:caption][:id]

      get caption_path(id), headers: auth_headers

      expect(json_response[:caption]).to match(hash_including({
                                                                url: url,
                                                                text: text,
                                                                caption_url: "/images/#{image_name}.jpg"
                                                              }))
    end

    context 'when requesting an inexistent resource' do
      it 'responds with 404' do
        get caption_path('foo'), headers: auth_headers

        expect(response).to have_http_status(:not_found)

        expect(json_response).to match(NotFoundError.body)
      end
    end

    context 'without authorization' do
      it 'responds with 401' do
        id = json_response[:caption][:id]

        get caption_path(id)

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with expired token' do
      it 'responds with 401' do
        id = json_response[:caption][:id]

        headers = Timecop.freeze(2.days.ago) { auth_headers }

        get caption_path(id), headers: headers

        expect(response).to have_http_status(:unauthorized)
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
      post captions_path, headers: auth_headers, params: params

      id = json_response[:caption][:id]

      delete caption_path(id), headers: auth_headers
      expect(response).to have_http_status(:ok)
    end

    context 'without authorization' do
      it 'responds with 401' do
        post captions_path, headers: auth_headers, params: params

        id = json_response[:caption][:id]

        delete caption_path(id)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with expired token' do
      it 'responds with 401' do
        headers = Timecop.freeze(2.days.ago) { auth_headers }

        post captions_path, headers: auth_headers, params: params

        id = json_response[:caption][:id]

        delete caption_path(id), headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
