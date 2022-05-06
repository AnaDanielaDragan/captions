# frozen_string_literal: true

require './lib/meme'

class CaptionsController < ApplicationController
  def index
    captions = Caption.all

    render json: { captions: captions }
  end

  def create
    attributes = params.require(:caption).permit(:url, :text)

    meme = Meme.new
    meme.image_url = attributes[:url]
    meme.text = attributes[:text]
    meme.create

    attributes[:caption_url] = Meme.file_path(meme.file_name)

    caption = Caption.create(attributes)

    render json: { caption: caption }, status: :created
  end

  def show
    caption = Caption.find(params[:id])

    render json: { caption: caption }
  end

  def destroy
    caption = Caption.find(params[:id])
    caption.destroy

    redirect_to caption_path(caption), status: :ok
  end
end
