# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'
require './lib/controllers/meme_controller'
require './lib/dtos/meme'
require './lib/services/image_download_service'

get '/' do
  meme_controller = MemeController.new
  meme_controller.execute
end
