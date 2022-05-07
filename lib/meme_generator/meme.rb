# frozen_string_literal: true

require_relative 'file_downloader'

class Meme
  @config = OpenStruct.new(images_dir: './images', test_mode: false)

  class << self
    attr_reader :config

    def configure
      yield(@config)
    end

    def file_path(file_name)
      # delete file after tests (see previous code)

      "#{@config.images_dir}/#{file_name}"
    end
  end

  attr_accessor :image_url, :text, :file_name

  def create
    save_image

    return if self.class.config.test_mode

    add_text
  end

  private

  def save_image
    generate_name(image_url, text)
    @meme_path = self.class.file_path(@file_name)

    FileDownloader.download_file(image_url, @meme_path)
  end

  def add_text
    image = MiniMagick::Image.new(@meme_path)
    image.combine_options do |c|
      c.gravity 'center'
      c.draw "text 0,0 \'#{text}\'"
      c.undercolor 'White'
      c.fill 'Black'
      c.font 'Helvetica'
      c.pointsize '60'
    end
  end

  def generate_name(url, text)
    file = Digest::MD5.hexdigest "#{url}, #{text}"
    @file_name = "#{file}.jpg"
  end
end
