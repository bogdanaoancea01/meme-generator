require 'sinatra/activerecord'
require './lib/services/user_input'
require './lib/errors/existing_user_error'
require './lib/errors/validation_error'
require './lib/services/password_hasher'
require 'dotenv/load'
require 'jwt'

class UserController
  JWT_SECRET_KEY = ENV['JWT_SECRET']

  def initialize(parser: UserInput.new)
    @parser = parser
  end

  def signup(body)
    new_user = @parser.parse(body)

    add_errors(new_user)

    raise ValidationError.new(new_user.errors.map { |e| { message: e.message } }) if new_user.errors.any?
    raise ExistingUserError if User.find_by(username: new_user.username)
    
    new_user.password = PasswordHasher.hash(new_user.password)
    new_user.token = generate_token(new_user.username)
    new_user.save

    new_user
  end

  def login(body)
    user = @parser.parse(body)
    return false if user.nil?

    found_user = User.find_by(username: user.username)
    return false if found_user.nil?

    return false unless PasswordHasher.check_hash(found_user.password, user.password)

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
    user.errors.add(:password, :blank, message: 'Password is blank') if user.password.nil? || user.password.empty?
  end
end
