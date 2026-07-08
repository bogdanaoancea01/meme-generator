# frozen_string_literal: true

class JsonParserService
  def parse(body, keyword)
    return nil if body.nil? || body.empty?

    root = body[keyword]
    return nil if root.nil? || root.empty?

    return Meme.new(root['image_url'], root['text']) if keyword == 'meme'

    User.new(username: root['username'], password: root['password']) if keyword == 'user'
  end
end
