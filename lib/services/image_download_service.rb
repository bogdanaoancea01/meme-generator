# frozen_string_literal: true

require 'open-uri'

class ImageDownloadService
  FOLDER_PATH = 'images/'

  def self.download(url)
    file_path = "#{FOLDER_PATH}original_#{rand(1..30_000)}.png"
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
