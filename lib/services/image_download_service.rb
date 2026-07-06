# frozen_string_literal: true

require 'open-uri'

class ImageDownloadService
  FOLDER_PATH = 'images/'
  MAX_FILE_SIZE_BYTES = 10 * 1024 * 1024

  def self.download(url)
    file_path = "#{FOLDER_PATH}original_#{SecureRandom.uuid}.png"

    begin
      URI.open(url) do |image|
        data = image.read(MAX_FILE_SIZE_BYTES + 1)
        return nil if data.bytesize > MAX_FILE_SIZE_BYTES
        File.binwrite(file_path, data)
      end
      file_path

    rescue StandardError
      nil
    end
  end
end
