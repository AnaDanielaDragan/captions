# frozen_string_literal: true

require './lib/meme_generator'

Meme.configure do |config|
  config.images_dir = 'spec/images'
  config.test_mode = true
end
