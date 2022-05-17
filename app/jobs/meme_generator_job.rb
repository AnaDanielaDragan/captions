# frozen_string_literal: true

require './lib/meme_generator'

class MemeGeneratorJob < ApplicationJob
  queue_as :default

  def perform(url, text)
    meme = Meme.new
    meme.image_url = url
    meme.text = text
    meme.create
  end
end
