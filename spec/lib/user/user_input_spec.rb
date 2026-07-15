# frozen_string_literal: true

require './lib/services/user_input'
require './lib/models/user'

RSpec.describe UserInput do
    describe '#parse' do
        context 'when the received JSON is empty' do
            let(:body) { {}.to_json } 

            it 'returns nil' do
                result = described_class.new.parse(JSON.parse(body))
                expect(result).to be(nil)
            end
        end

        context 'when the JSON does not describe a user' do
            let(:body) { { wrong_root: { username: "mr_bean", password: "test123" }}.to_json }

            it 'returns nil' do
                result = described_class.new.parse(JSON.parse(body))

                expect(result).to be(nil)
            end
        end

        context 'when the JSON describes a user' do
            let(:body) { { user: { username: "mr_bean", password: "test123" }}.to_json }

            it 'returns a user object' do
                result = described_class.new.parse(JSON.parse(body))

                expect(result).to be_a(User)

                expect(result.username).to eq('mr_bean')
                expect(result.password).to eq('test123')
            end
        end
    end
end