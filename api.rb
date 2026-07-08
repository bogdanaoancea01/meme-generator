# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'bcrypt'
require './lib/controllers/meme_controller'
require './lib/controllers/user_controller'
require './lib/dtos/meme'
require './lib/services/image_download_service'
require './lib/models/user'

set :database_file, 'config/database.yml'

helpers do
  def authorization!
    token = request.env['HTTP_AUTHORIZATION']&.split&.last
    halt 401 if token.nil?

    user = User.find_by(token: token)
    halt 401 unless user
  end
end

post '/memes' do
  authorization!

  body = JSON.parse(request.body.read)

  response = MemeController.new.execute(body)

  if response.message.nil?
    redirect "/memes/#{response.redirect_url}", 303
  else
    halt 400, { 'Content-Type' => 'application/json' }, { message: response.message }.to_json
  end
end

get '/memes/:file' do
  path = File.join('images', File.basename(params[:file]))
  send_file(path)
end

post '/signup' do
  body = JSON.parse(request.body.read)
  new_user = UserController.new.signup(body)

  halt 409, { 'Content-Type' => 'application/json' }, '' if new_user.nil?

  if new_user.errors.any?
    halt 400, { 'Content-Type' => 'application/json' }, { errors: new_user.errors.map do |e|
      { message: e.message }
    end }.to_json
  end

  [201, { 'Content-Type' => 'application/json' }, { token: new_user.token }.to_json]
end

post '/login' do
  body = JSON.parse(request.body.read)

  login_response = UserController.new.login(body)

  halt 409 unless login_response

  [200, { 'Content-Type' => 'application/json' }, { token: login_response }.to_json]
end
