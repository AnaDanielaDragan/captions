# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'InstagramCaptions', type: :request do
  describe 'POST /captions/instagram' do
    subject(:post_instagram_caption) { post instagram_captions_path, headers: auth_headers, params: params }

    let(:url) { Faker::LoremFlickr.image }
    let(:text) { Faker::TvShows::GameOfThrones.quote }
    let(:image_name) { Digest::MD5.hexdigest "#{url}, #{text}" }
    let(:params) do
      {
        image: {
          content_type: 'image',
          url: url,
          text: text
        }
      }
    end

    it 'responds with 201' do
      post_instagram_caption

      expect(response).to have_http_status(:created)
    end

    it 'responds with correct body' do
      post_instagram_caption

      expect(json_response[:caption]).to match(hash_including({
                                                                content_type: "image",
                                                                url: url,
                                                                text: text # ,
                                                                # caption_url: "/images/#{image_name}.jpg"
                                                              }))
    end

    context 'with invalid body' do
      let(:params) do
        {
          image: {
            uri: url,
            cats: text
          }
        }
      end

      it 'responds with 422' do
        post_instagram_caption

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to match(MissingParametersError.body)
      end
    end

    context 'with invalid params' do
      let(:url) { SecureRandom.hex }
      let(:text) { nil }
      let(:image_name) { Digest::MD5.hexdigest "#{url}, #{text}" }
      let(:params) do
        {
          image: {
            content_type: 'foo',
            url: url,
            text: text
          }
        }
      end

      it 'responds with 422' do
        post_instagram_caption

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to match(MissingParametersError.body)
      end
    end

    context 'with a filter parameter' do
      let(:filter) { 'blackwhite' }
      let(:params) do
        {
          image: {
            content_type: 'image',
            url: url,
            text: text,
            filter: filter
          }
        }
      end

      it 'responds with 201' do
        post_instagram_caption

        expect(response).to have_http_status(:created)
      end

      it 'responds with correct body' do
        post_instagram_caption

        expect(json_response[:caption]).to match(hash_including({
                                                                  content_type: 'image',
                                                                  url: url,
                                                                  text: text,
                                                                  filter: filter # ,
                                                                  # caption_url: "/images/#{image_name}.jpg"
                                                                }))
      end

      context 'with content type other than image' do
        let(:params) do
          {
            image: {
              content_type: 'color',
              url: url,
              text: text,
              filter: 'blackwhite'
            }
          }
        end

        it 'responds with 422' do
          post_instagram_caption

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'with color as content type' do
      let(:text) { Faker::TvShows::GameOfThrones.quote }
      let(:image_name) { Digest::MD5.hexdigest "#{url}, #{text}" }
      let(:color) { '#003166' }
      let(:params) do
        {
          image: {
            content_type: 'color',
            color: color,
            text: text
          }
        }
      end

      it 'responds with 201' do
        post_instagram_caption

        expect(response).to have_http_status(:created)
      end

      it 'responds with correct body' do
        post_instagram_caption

        expect(json_response[:caption]).to match(hash_including({
                                                                  content_type: 'color',
                                                                  color: color,
                                                                  text: text # ,
                                                                  # caption_url: "/images/#{image_name}.jpg"
                                                                }))
      end
    end

    context 'with gradient as content type' do
      let(:text) { Faker::TvShows::GameOfThrones.quote }
      let(:image_name) { Digest::MD5.hexdigest "#{url}, #{text}" }
      let(:start_color) { '#000000' }
      let(:end_color) { '#003166' }
      let(:params) do
        {
          image: {
            content_type: 'gradient',
            start_color: start_color,
            end_color: end_color,
            text: text
          }
        }
      end

      it 'responds with 201' do
        post_instagram_caption

        expect(response).to have_http_status(:created)
      end

      it 'responds with correct body' do
        post_instagram_caption

        expect(json_response[:caption]).to match(hash_including({
                                                                  content_type: 'gradient',
                                                                  start_color: start_color,
                                                                  end_color: end_color,
                                                                  text: text # ,
                                                                  # caption_url: "/images/#{image_name}.jpg"
                                                                }))
      end
    end
  end

  describe 'GET /captions/instagram' do
    subject(:get_instagram_captions) { get instagram_captions_path, headers: auth_headers}

    it 'responds with 200' do
      get_instagram_captions

      expect(response).to have_http_status(:ok)
    end

    it 'responds with correct body' do
      get_instagram_captions

      expect(json_response).to eq({ captions: [] })
    end

    context 'with existent caption' do
      let(:url) { Faker::LoremFlickr.image }
      let(:text) { Faker::TvShows::GameOfThrones.quote }
      let(:image_name) { Digest::MD5.hexdigest "#{url}, #{text}" }
      let(:params) do
        {
          image: {
            content_type: 'image',
            url: url,
            text: text
          }
        }
      end

      before { post instagram_captions_path, headers: auth_headers, params: params }

      it 'responds with 201' do
        expect(response).to have_http_status(:created)

        get_instagram_captions

        expect(response).to have_http_status(:ok)
      end

      it 'responds with correct body' do
        id = json_response[:caption][:id]

        get_instagram_captions

        expect(json_response[:captions]).to include(hash_including({
                                                                     id: id,
                                                                     content_type: "image",
                                                                     url: url,
                                                                     text: text # ,
                                                                     # caption_url: "/images/#{image_name}.jpg"
                                                                   }))
      end
    end
  end
end
