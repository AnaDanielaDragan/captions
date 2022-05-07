# frozen_string_literal: true

require './lib/meme'

Meme.configure do |config|
  config.images_dir = 'spec/images'
end
