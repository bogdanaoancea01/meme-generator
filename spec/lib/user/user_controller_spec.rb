# frozen_string_literal: true

require '././lib/controllers/user_controller'
require './lib/dtos/auth_response'

RSpec.describe UserController do
    describe "#signup" do
        context 'when username and password are present' do
            let(:body) { File.read('spec/fixtures/user/user_test.json') }

            it 'returns a created AuthResponse with a token' do
                result = described_class.new.signup(JSON.parse(body))

                expect(result).to be_a(AuthResponse)
                expect(result.outcome).to eq(:created)
                expect(result.token).not_to be_nil
            end

            it 'saves the user with a hashed password' do
                described_class.new.signup(JSON.parse(body))

                saved_user = User.find_by(username: 'mr_bean')
                expect(saved_user).not_to be_nil
                expect(saved_user.password).not_to eq('test123')
                expect(BCrypt::Password.new(saved_user.password)).to eq('test123')
            end
        end

        context 'when username is missing' do
            let(:body) { File.read('spec/fixtures/user/no_username_test.json') }

            it 'returns an invalid AuthResponse with a blank username error' do
                result = described_class.new.signup(JSON.parse(body))

                expect(result).to be_a(AuthResponse)
                expect(result.outcome).to eq(:invalid)
                expect(result.errors[:username]).to include('Username is blank')
            end
        end

        context 'when password is missing' do
            let(:body) { File.read('spec/fixtures/user/no_password_test.json') }

            it 'returns an invalid AuthResponse with a blank password error' do
                result = described_class.new.signup(JSON.parse(body))

                expect(result).to be_a(AuthResponse)
                expect(result.outcome).to eq(:invalid)
                expect(result.errors[:password]).to include('Password is blank')
            end
        end

        context 'when the username already exists' do
            let(:body) { File.read('spec/fixtures/user/user_test.json') }

            before do
            User.create!(username: 'mr_bean', password: BCrypt::Password.create('test123').to_s)
            end

            it 'returns an already_in_db AuthResponse' do
                result = described_class.new.signup(JSON.parse(body))

                expect(result).to be_a(AuthResponse)
                expect(result.outcome).to eq(:already_in_db)
            end
        end
    end

    describe "#login" do
        context 'when username and password match' do
            before do
                User.create!(username: 'mr_bean', password: BCrypt::Password.create('test123').to_s)
            end

            let(:body) { File.read('spec/fixtures/user/user_test.json') }

            it 'returns a token' do
                result = described_class.new.login(JSON.parse(body))

                expect(result).to be_a(String)
                expect(result).not_to be_nil
            end
        end

        context 'when username and password match' do
            before do
                User.create!(username: 'mr_bean', password: BCrypt::Password.create('wrong_pass').to_s)
            end

            let(:body) { File.read('spec/fixtures/user/user_test.json') }

            it 'returns false' do
                result = described_class.new.login(JSON.parse(body))

                expect(result).to be(false)
            end
        end

        context 'when username does not exist' do
            let(:body) { File.read('spec/fixtures/user/user_test.json') }

            it 'returns false' do
                result = described_class.new.login(JSON.parse(body))

                expect(result).to be(false)
            end
        end
    end
end