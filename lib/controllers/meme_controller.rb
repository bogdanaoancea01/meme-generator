# frozen_string_literal: true

require './lib/services/image_download_service'
require './lib/services/meme_generator_service'
require './lib/dtos/meme'
require './lib/dtos/response'
require './lib/services/json_parser_service'
require 'json'

class MemeController
  def execute(body)
    meme = JsonParserService.new.parse(body)
    error_message = validate_meme(meme)

    return Response.new(message: error_message) if error_message

    downloaded_image_path = ImageDownloadService.download(meme.image_url)

    return Response.new(message: 'Failed to download image') if downloaded_image_path.nil?

    generated_image_path = MemeGeneratorService.generate(downloaded_image_path, meme.text)

    Response.new(redirect_url: File.basename(generated_image_path))
  end

  private

  def validate_meme(meme)
    return 'Empty body' if meme.nil?
    return 'Check URL field' if meme.image_url.to_s.empty?

    'Check text field' if meme.text.to_s.empty?
  end
end
