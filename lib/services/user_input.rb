# frozen_string_literal: true

require './lib/models/user'

class UserInput
    def parse(body)
        return nil if body.nil? || body.empty?

        root = body['user']
        return nil if root.nil? || root.empty?

        User.new(username: root['username'], password: root['password'])
    end
end