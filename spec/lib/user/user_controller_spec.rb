# frozen_string_literal: true

require '././lib/controllers/user_controller'

RSpec.describe UserController do
    describe "#signup" do
        context 'when username and password are present' do
            let (:body) { File.read('spec/fixtures/user/user_test.json') }

            it 'returns a User with the given username and password' do
                result = described_class.new.signup(JSON.parse(body))

                expect(result).to be_a(User)
                expect(result.username).to eq('mr_bean')
                expect(result.password).to eq('test123')
                expect(result.errors).to be_empty
            end
        end

        context 'when username is missing' do
            let (:body) { File.read('spec/fixtures/user/no_username_test.json') }

            it 'adds a blank username error' do
                result = described_class.new.signup(JSON.parse(body))

                expect(result).to be_a(User)

                expect(result.errors[:username]).to include('Username is blank')
            end
        end

        context 'when password is missing' do
            let (:body) { File.read('spec/fixtures/user/no_password_test.json') }

            it 'adds a blank password error' do
                result = described_class.new.signup(JSON.parse(body))

                expect(result).to be_a(User)

                expect(result.errors[:password]).to include('Password is blank')
            end
        end
    end

    describe "#login" do
        context 'when username and password match' do
            before do
                User.create!(username: 'mr_bean', password: BCrypt::Password.create('test123').to_s)
            end

            let(:body) { File.read('spec/fixtures/user/user_test.json') }

            it 'returns true' do
                result = described_class.new.login(JSON.parse(body))

                expect(result).to be(true)
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