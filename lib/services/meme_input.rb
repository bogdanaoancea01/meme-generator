# frozen_string_literal: true

require './lib/models/user'

class MemeInput
    def parse(body)
        return nil if body.nil? || body.empty?

        root = body['meme']
        return nil if root.nil? || root.empty?

        Meme.new(root['image_url'], root['text'])
    end
end