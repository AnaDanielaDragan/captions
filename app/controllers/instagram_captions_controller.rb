class InstagramCaptionsController < ApplicationController
  def index
    instagram_captions = InstagramCaption.all

    render json: { captions: instagram_captions }
  end

  def create
    attributes = params.require(:image).permit(:content_type, :url, :text, :filter, :color, :start_color, :end_color)

    # TODO
    # # Implement meme for instagram
    # # Treat invalid body separate (how to check optional params?)

    instagram_caption = InstagramCaption.new(attributes)
    instagram_caption.save!

    render json: { caption: instagram_caption }, status: :created
  rescue ActiveRecord::RecordInvalid
    render json: MissingParametersError.body, status: :unprocessable_entity
  end
end
