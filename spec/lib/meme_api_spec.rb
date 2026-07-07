# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require_relative '../../api'
require 'rspec'
require 'rack/test'
require './lib/controllers/meme_controller'
require './lib/dtos/meme_response'
require_relative '../spec_helper'

RSpec.describe 'Meme API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:user) { User.create!(username: 'mr_bean', password: BCrypt::Password.create('test123').to_s, token: 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6Im1yX2JlYW4ifQ.A38hP8ZL1AZm7fNPxROjqWu6RslI_elhH_u6QIXOgoA') }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => "Bearer #{user.token}" } }


  context 'when the request is correct' do
    let(:body) { File.read('spec/fixtures/meme_test.json') }

    it 'returns status code 303' do
      post '/memes', body, headers

      expect(last_response.status).to eq(303)
    end
  end

  context 'when the request is missing URL' do
    let(:body) { File.read('spec/fixtures/no_link_test.json') }

    it 'returns status code 400' do
      post '/memes', body, headers

      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)['message']
      expect(response_body).to include('Check URL field')
    end
  end

  context 'when the request is missing text' do
    let(:body) { File.read('spec/fixtures/no_text_test.json') }

    it 'returns status code 400' do
      post '/memes', body, headers

      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)['message']
      expect(response_body).to include('Check text field')
    end
  end

  context 'when the request has a wrong URL' do
    let(:body) { File.read('spec/fixtures/wrong_url_test.json') }

    it 'returns status code 400' do
      post '/memes', body, headers

      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)['message']
      expect(response_body).to include('Failed to download image')
    end
  end

  context 'when the request is empty' do
    let(:body) { File.read('spec/fixtures/empty_json_test.json') }

    it 'returns status code 400' do
      post '/memes', body, headers

      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)['message']
      expect(response_body).to include('Empty body')
    end
  end

  context 'when no Authorization header is provided' do
    let(:body) { File.read('spec/fixtures/meme_test.json') }

    it 'returns 401' do
      post '/memes', body

      expect(last_response.status).to eq(401)
    end
  end

  context 'when the token does not match any user' do
    let(:body) { File.read('spec/fixtures/meme_test.json') }
    let(:user) { User.create!(username: 'mr_bean', password: BCrypt::Password.create('test123').to_s, token: 'WRONG_TOKEN..xBeO') }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => "Bearer #{user.token}" } }

    it 'returns 401' do
      post '/memes', body, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => 'Bearer garbage_token' }

      expect(last_response.status).to eq(401)
    end
  end
end