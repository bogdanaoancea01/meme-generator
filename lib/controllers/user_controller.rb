require 'sinatra/activerecord'
require './lib/services/json_parser_service'
require 'dotenv/load'
require 'jwt'

class UserController
  JWT_SECRET_KEY = ENV['JWT_SECRET']

  def initialize(parser: JsonParserService.new)
    @parser = parser
  end

  def signup(body)
    new_user = @parser.parse(body, 'user')

    add_errors(new_user)

    return new_user if new_user.errors.any?
    return nil if User.find_by(username: new_user.username)

    new_user.password = BCrypt::Password.create(new_user.password).to_s
    new_user.token = generate_token(new_user.username)
    new_user.save

    new_user
  end

  def login(body)
    user = @parser.parse(body, 'user')
    return false if user.nil?

    found_user = User.find_by(username: user.username)
    return false if found_user.nil?

    return false unless BCrypt::Password.new(found_user.password) == user.password

    found_user.token = generate_token(found_user.username)
    found_user.save
    found_user.token
  end

  private

  def generate_token(username)
    payload = { username: username }
    JWT.encode(payload, JWT_SECRET_KEY, 'HS256')
  end

  def add_errors(user)
    user.errors.add(:username, :blank, message: 'Username is blank') if user.username.nil? || user.username.empty?

    return unless user.password.nil? || user.password.empty?

    user.errors.add(:password, :blank, message: 'Password is blank')
  end
end
