# frozen_string_literal: true

require './lib/file_downloader'

class Meme
  attr_accessor :image_url, :text, :file_name

  def create
    save_image
    add_text
  end

  def self.file_path(file_name)
    # delete file after tests (see previous code)
    "images/#{file_name}"
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
    @file_name = "#{file}.png"
  end
end
