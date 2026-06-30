# frozen_string_literal: true

require 'open-uri'

class ImageDownloadService
  FOLDER_PATH = 'images/'

  def self.download(url)
    file_path = "#{FOLDER_PATH}random_#{rand(1..30_000)}.jpg"
    begin
      URI.open(url) do |img|
        File.binwrite(file_path, img.read)
      end
      file_path
    rescue StandardError
      nil
    end
  end
end
