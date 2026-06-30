# frozen_string_literal: true

require './lib/services/image_download_service'
require './lib/dtos/meme'
require './lib/dtos/response'

class MemeController
  def execute
    meme_info = Meme.new('https://picsum.photos/200', 'Generate description')
    img_service_response = ImageDownloadService.download(meme_info.image_url)

    if img_service_response.nil?
      Response.new(400)
    else
      Response.new(303, 'https://picsum.photos/200')
    end
  end
end
