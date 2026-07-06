# frozen_string_literal: true

require 'mini_magick'

class MemeGeneratorService
  def generate(file_path, text)
    generated_file_path = file_path.sub(/original_/, 'generated_')
    image = MiniMagick::Image.open(file_path)
    image.combine_options do |c|
      c.gravity 'center'
      c.fill 'black'
      c.undercolor 'white'
      c.font '/System/Library/Fonts/Helvetica.ttc'
      c.pointsize 20
      c.draw %(text 0,50 "#{text}")
    end
    image.write(generated_file_path)

    generated_file_path
  end
end
