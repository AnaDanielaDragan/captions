class InstagramCaptionsController < ApplicationController
  def create
    attributes = params.require(:image).permit(:content_type, :url, :text)

    instagram_caption = InstagramCaption.create(attributes)

    render json: { caption: instagram_caption }, status: :created
  end
end
