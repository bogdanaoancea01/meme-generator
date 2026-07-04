# frozen_string_literal: true

require './lib/services/image_download_service'
require './lib/services/meme_generator_service'
require './lib/dtos/meme'
require './lib/dtos/response'
require "json"

class MemeController
  def execute(body)

    if body.nil? || body.empty?
      return Response.new(400, "Empty body")
    end

    meme_json = body["meme"]

    meme_info = Meme.new(
      meme_json["image_url"],
      meme_json["text"]
    )

    if meme_info.image_url.nil? || meme_info.text.nil?
      return Response.new(400, "Check url and text fields")
    end

    img_service_response = ImageDownloadService.download(meme_info.image_url)

    if img_service_response.nil?
      Response.new(400, "No image downloaded")
    else
      meme_service_response = MemeGeneratorService.generate(img_service_response, meme_info.text)

      Response.new(303, "Success", File.basename(meme_service_response))
    end
  end
end
