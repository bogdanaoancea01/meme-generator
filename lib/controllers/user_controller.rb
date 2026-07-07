require 'sinatra/activerecord'
require './lib/services/json_parser_service'
require 'jwt'


class UserController
    JWT_SECRET = ENV.fetch('JWT_SECRET', 'super_secret_key')

    def initialize(parser: JsonParserService.new)
        @parser = parser
    end

  def signup(body)
    new_user = @parser.parse(body, 'user')

    if new_user.username.nil? || new_user.username.empty?
      new_user.errors.add(:username, :blank, message: 'Username is blank')
    end

    if new_user.password.nil? || new_user.password.empty?
      new_user.errors.add(:password, :blank, message: 'Password is blank')
    end

    new_user
  end

  def login(body)
    user = @parser.parse(body, 'user')
    return false if user.nil?

    found_user = User.find_by(username: user.username)
    return false if found_user.nil?

    if BCrypt::Password.new(found_user.password) == user.password
        payload = { username: found_user.username, exp: Time.now.to_i + 3600 }
        token = JWT.encode(payload, JWT_SECRET, 'HS256')
        return token
    else
        return false
    end
  end
end