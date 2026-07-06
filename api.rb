# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require 'json'
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
