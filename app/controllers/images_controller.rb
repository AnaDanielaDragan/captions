# frozen_string_literal: true

class ImagesController < ApplicationController
  def show
    img_name = [params[:id], params[:format]].join('.')

    if File.exist?("#{Meme.config.images_dir}/#{img_name}")
      # mai asteptam

      head :ok
    else
      head :not_found
    end
  end
end
