# frozen_string_literal: true

require './lib/services/image_download_service'
require './lib/services/meme_generator_service'
require './lib/dtos/meme'
require './lib/dtos/response'

class MemeController
  def execute
    meme_info = Meme.new('https://picsum.photos/200', 'Generate description')
    img_service_response = ImageDownloadService.download(meme_info.image_url)

    if img_service_response.nil?
      Response.new(400)
    else
      meme_service_response = MemeGeneratorService.generate(img_service_response, meme_info.text)

      Response.new(303, File.basename(meme_service_response))
    end
  end
end
