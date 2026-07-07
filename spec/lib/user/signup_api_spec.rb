# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require_relative '../../../api'
require 'rspec'
require 'rack/test'
require_relative '../../spec_helper'

RSpec.describe 'Signup API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'sign up user' do
    let(:body) { File.read('spec/fixtures/user/user_test.json') }

    it 'returns status code 201 and user token' do
      post '/signup', body, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(201)
      response_body = JSON.parse(last_response.body)['token']
      expect(JSON.parse(last_response.body)['token']).not_to be_nil
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