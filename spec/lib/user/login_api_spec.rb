# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require_relative '../../../api'
require 'rspec'
require 'rack/test'
require_relative '../../spec_helper'

RSpec.describe 'Login API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

    context 'when the username does not exist' do
        let(:body) { File.read('spec/fixtures/user/user_test.json') }

        it 'returns status code 409' do
            post '/login', body, { 'CONTENT_TYPE' => 'application/json' }

            expect(last_response.status).to eq(409)
        end
    end

    context 'when the password is incorrect' do
        let(:body) { File.read('spec/fixtures/user/user_test.json') }

        before do
            User.create!(username: 'mr_bean', password: BCrypt::Password.create('wrong_password').to_s)
        end

        it 'returns status code 409' do
            post '/login', body, { 'CONTENT_TYPE' => 'application/json' }

            expect(last_response.status).to eq(409)
        end
    end

    context 'when username and password are correct' do
        let(:body) { File.read('spec/fixtures/user/user_test.json') }

        before do
            User.create!(username: 'mr_bean', password: BCrypt::Password.create('test123').to_s,
                token: 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6Im1yX2JlYW4ifQ.fJOusXI5JFp6VqcRTr9frQlhI9Wx0Rxv953NAUyYo0w')
        end

        it 'returns status code 200 and a token' do
            post '/login', body, { 'CONTENT_TYPE' => 'application/json' }

            expect(last_response.status).to eq(200)
            token = JSON.parse(last_response.body)['token']
            expect(token).not_to be_nil
        end


        it 'returns 200 and a valid token' do
            post '/login', body, { 'CONTENT_TYPE' => 'application/json' }

            expect(last_response.status).to eq(200)
            token = JSON.parse(last_response.body)['token']
            decoded_payload, = JWT.decode(token, UserController::JWT_SECRET_KEY, true, algorithm: 'HS256')
            expect(decoded_payload['username']).to eq('mr_bean')
        end
    end
end