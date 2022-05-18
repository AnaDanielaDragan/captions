# frozen_string_literal: true

require './lib/meme_generator'

class CaptionsController < ApplicationController
  def index
    captions = Caption.all

    render json: { captions: captions }
  end

  def create
    attributes = params.require(:caption).permit(:url, :text)

    unless attributes.key?(:url) && attributes.key?(:text)
      return render json: BadRequestError.body,
                    status: :bad_request
    end

    meme = Meme.new
    meme.image_url = attributes[:url]
    meme.text = attributes[:text]
    meme.create
    # MemeGeneratorJob.perform_later(attributes[:url], attributes[:text])

    caption = Caption.new(attributes)
    caption.caption_url = "/images/#{meme.file_name}"
    caption.save!

    # TODO:
    # return status 202, no other result
    # see in show, separate endpoint, the result

    # after job is done, send mailer that job was processed, with result (server: request http, in functie de client)
    render json: { caption: caption }, status: :accepted
  rescue InvalidFileUriError, ActiveRecord::RecordInvalid
    render json: MissingParametersError.body, status: :unprocessable_entity
  end

  def show
    caption = Caption.find(params[:id])

    render json: { caption: caption }
  rescue ActiveRecord::RecordNotFound
    render json: NotFoundError.body, status: :not_found
  end

  def destroy
    caption = Caption.find(params[:id])
    caption.destroy

    redirect_to caption_path(caption), status: :ok
  end
end
