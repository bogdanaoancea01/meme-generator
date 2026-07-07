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
  result = UserController.new.signup(body)

  return [409, { 'Content-Type' => 'application/json' }, ''] if result.nil?

  if result.errors.any?
    return [400, { 'Content-Type' => 'application/json' }, { errors: result.errors.map { |e| { message: e.message } } }.to_json]
  end

  [201, { 'Content-Type' => 'application/json' }, { token: result.token }.to_json]
end

post '/login' do
  body = JSON.parse(request.body.read)
  
  login_response = UserController.new.login(body)

  return [409, { 'Content-Type' => 'application/json' }, ''] if !login_response 

  [200, { 'Content-Type' => 'application/json' }, { token: login_response }.to_json]

end