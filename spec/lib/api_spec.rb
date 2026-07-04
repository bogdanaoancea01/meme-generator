ENV['APP_ENV'] = 'test'

require_relative '../../api'
require 'rspec'
require 'rack/test'
require './lib/controllers/meme_controller'
require './lib/dtos/response'

RSpec.describe 'Meme API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context "when the request is correct" do 
    let(:body) {File.read('spec/fixtures/meme_test.json')}

    it "it returns status code 303" do
      post '/memes', body, {'CONTENT_TYPE' => 'application/json'}

      expect(last_response.status).to eq(303)
    end
  end

  context "when the request is missing URL" do 
    let(:body) {File.read('spec/fixtures/no_link_test.json')}
    
    it "returns status code 400" do
      post '/memes', body, {'CONTENT_TYPE' => 'application/json'}

      expect(last_response.status).to eq(400)
    end
  end

  context "when the request is missing text" do 
    let(:body) {File.read('spec/fixtures/no_text_test.json')}
    
    it "returns status code 400" do
      post '/memes', body, {'CONTENT_TYPE' => 'application/json'}

      expect(last_response.status).to eq(400)
    end
  end

  context "when the request has a wrong URL" do 
    let(:body) {File.read('spec/fixtures/wrong_url_test.json')}
    
    it "returns status code 400" do
      post '/memes', body, {'CONTENT_TYPE' => 'application/json'}

      expect(last_response.status).to eq(400)
    end
  end

  context "when the request is empty" do 
    let(:body) {File.read('spec/fixtures/empty_json_test.json')}
    
    it "returns status code 400" do
      post '/memes', body, {'CONTENT_TYPE' => 'application/json'}

      expect(last_response.status).to eq(400)
    end
  end
end