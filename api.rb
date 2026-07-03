# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'
require "json"
require './lib/controllers/meme_controller'
require './lib/dtos/meme'
require './lib/services/image_download_service'

post "/memes" do
  body = JSON.parse(request.body.read)

  response = MemeController.new.execute(body)

  redirect "/memes/#{response.redirect_url}", response.response_status
end

get "/memes/:file" do
  path = File.join("images", File.basename(params[:file]))
  send_file(path)
end