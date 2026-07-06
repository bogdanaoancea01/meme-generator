# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'bcrypt'
require './lib/controllers/meme_controller'
require './lib/dtos/meme'
require './lib/services/image_download_service'
require './lib/models/user'


set :database_file, 'config/database.yml'

post '/memes' do
  body = JSON.parse(request.body.read)

  response = MemeController.new.execute(body)

  if response.message.nil?
    redirect "/memes/#{response.redirect_url}", 303
  else
    [400, { 'Content-Type' => 'application/json' }, { message: response.message }.to_json]
  end
end

get '/memes/:file' do
  path = File.join('images', File.basename(params[:file]))
  send_file(path)
end

post '/signup' do
  body = JSON.parse(request.body.read)
  body = body['user']

  new_user = User.new(username: body['username'], password: body['password'])

  if new_user.username.nil? || new_user.username.empty?
    new_user.errors.add(:username, :blank, message: 'Username is blank')
  end

  if new_user.password.nil? || new_user.password.empty?
    new_user.errors.add(:password, :blank, message: 'Password is blank')
  end

  if User.find_by(username: body['username'])
    return [409, { 'Content-Type' => 'application/json' }, '']
  end

  if new_user.errors.any?
    return [
      400,
      { 'Content-Type' => 'application/json' },
      { errors: new_user.errors.map { |error| { message: error.message } } }.to_json
    ]
  end

  new_user.password = BCrypt::Password.create(body['password']).to_s
  new_user.save

  [201, { 'Content-Type' => 'application/json' }, { token: 'aaaa' }.to_json]
end