require 'sinatra/activerecord'
require 'json'

class UserController
  def execute(request)
    body = JSON.parse(request)
    body = body['user']

    new_user = User.new(username: body['username'], password: body['password'])

    if new_user.username.nil? || new_user.username.empty?
      new_user.errors.add(:username, :blank, message: 'Username is blank')
    end

    if new_user.password.nil? || new_user.password.empty?
      new_user.errors.add(:password, :blank, message: 'Password is blank')
    end

    new_user
  end
end