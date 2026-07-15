# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'bcrypt'
require './lib/controllers/meme_controller'
require './lib/controllers/user_controller'
require './lib/models/meme'
require './lib/services/image_download_service'
require './lib/models/user'
require './lib/errors/existing_user_error'

set :database_file, 'config/database.yml'

helpers do
  def authorization!
    token = request.env['HTTP_AUTHORIZATION']&.split&.last
    halt 401 if token.nil?

    user = User.find_by(token: token)
    halt 401 unless user
  end
end

error ExistingUserError do
  409
end

error ValidationError do
  error = env['sinatra.error']
  halt 400, { 'Content-Type' => 'application/json' }, { errors: error.errors }.to_json
end

post '/memes' do
  authorization!

  body = JSON.parse(request.body.read)

  response = MemeController.new.execute(body)

  if response.message.nil?
    redirect "/memes/#{response.redirect_url}", 307
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

  [201, { 'Content-Type' => 'application/json' }, { token: new_user.token }.to_json]
end

post '/login' do
  body = JSON.parse(request.body.read)

  login_response = UserController.new.login(body)

  halt 409 unless login_response

  [200, { 'Content-Type' => 'application/json' }, { token: login_response }.to_json]
end
