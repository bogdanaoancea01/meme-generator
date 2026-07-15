# frozen_string_literal: true

require './lib/services/image_download_service'
require './lib/services/meme_generator_service'
require './lib/models/meme'
require './lib/dtos/meme_response'
require './lib/services/meme_input'
require 'json'

class MemeController
  def initialize(downloader: ImageDownloadService.new, generator: MemeGeneratorService.new,
                 parser: MemeInput.new)
    @downloader = downloader
    @generator = generator
    @parser = parser
  end

  def execute(body)
    meme = @parser.parse(body)

    error_message = validate_meme(meme)
    return MemeResponse.new(message: error_message) if error_message

    downloaded_image_path = @downloader.download(meme.image_url)
    return MemeResponse.new(message: 'Failed to download image') if downloaded_image_path.nil?

    generated_image_path = @generator.generate(downloaded_image_path, meme.text)
    MemeResponse.new(redirect_url: File.basename(generated_image_path))
  end

  private

  def validate_meme(meme)
    return 'Empty body' if meme.nil?
    return 'Check URL field' if meme.image_url.to_s.empty?

    'Check text field' if meme.text.to_s.empty?
  end
end
