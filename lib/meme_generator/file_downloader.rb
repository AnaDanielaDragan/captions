# frozen_string_literal: true

require_relative 'invalid_file_uri_error'

class FileDownloader
  def self.download_file(image_url, path)
    uri = URI.parse(image_url)

    uri.open do |file_from_uri|
      File.binwrite(path, file_from_uri.read)
    end
  rescue StandardError
    raise InvalidFileUriError
  end
end
