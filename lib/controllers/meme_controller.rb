# frozen_string_literal: true

require './lib/services/image_download_service'
require './lib/services/meme_generator_service'
require './lib/dtos/meme'
require './lib/dtos/response'
require './lib/controllers/json_parser.rb'
require "json"

class MemeController
  def execute(body)

    meme_info = JsonParser.new.parse(body)

    return Response.new(400, "Empty body") if meme_info.nil?

    if meme_info.image_url.nil? || meme_info.image_url.empty?
      return Response.new(400, "Check URL field")
    end

    if meme_info.text.nil? || meme_info.text.empty?
      return Response.new(400, "Check text field")
    end

    img_service_response = ImageDownloadService.download(meme_info.image_url)

    return Response.new(400, "No image downloaded") if img_service_response.nil?

    meme_service_response = MemeGeneratorService.generate(img_service_response, meme_info.text)

    Response.new(303, "Success", File.basename(meme_service_response))

  end
end
