# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require_relative '../../api'
require 'rspec'
require 'rack/test'
require './lib/controllers/meme_controller'
require './lib/dtos/response'
require_relative '../spec_helper'

RSpec.describe 'Meme API' do

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'when the request is correct' do
    let(:body) { File.read('spec/fixtures/meme_test.json') }

    it 'it returns status code 303' do
      post '/memes', body, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(303)
    end
  end

  context 'when the request is missing URL' do
    let(:body) { File.read('spec/fixtures/no_link_test.json') }

    it 'returns status code 400' do
      post '/memes', body, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)['message']
      expect(response_body).to include('Check URL field')
    end
  end

  context 'when the request is missing text' do
    let(:body) { File.read('spec/fixtures/no_text_test.json') }

    it 'returns status code 400' do
      post '/memes', body, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)['message']
      expect(response_body).to include('Check text field')
    end
  end

  context 'when the request has a wrong URL' do
    let(:body) { File.read('spec/fixtures/wrong_url_test.json') }

    it 'returns status code 400' do
      post '/memes', body, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)['message']
      expect(response_body).to include('Failed to download image')
    end
  end

  context 'when the request is empty' do
    let(:body) { File.read('spec/fixtures/empty_json_test.json') }

    it 'returns status code 400' do
      post '/memes', body, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)['message']
      expect(response_body).to include('Empty body')
    end
  end

  context 'sign up user' do
    let(:body) { File.read('spec/fixtures/user/user_test.json') }

    it 'returns status code 201 and user token' do
      post '/signup', body, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(201)
      response_body = JSON.parse(last_response.body)['token']
      expect(response_body).to include('aaaa')
    end
  end

  context 'the username does not exist in the request' do
    let(:body) { File.read('spec/fixtures/user/no_username_test.json') }

    it 'returns status code 400 and error message' do
      post '/signup', body, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)['errors']
      expect(response_body).to include({ "message" => "Username is blank" })
    end
  end

  context 'the password does not exist in the request' do
    let(:body) { File.read('spec/fixtures/user/no_password_test.json') }

    it 'returns status code 400 and error message' do
      post '/signup', body, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)['errors']
      expect(response_body).to include({ "message" => "Password is blank" })
    end
  end

  context 'when the username already exists' do
    let(:body) { File.read('spec/fixtures/user/user_test.json') }

    it 'returns 409' do
      post '/signup', body, { 'CONTENT_TYPE' => 'application/json' }
      post '/signup', body, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(409)
    end
  end
end
