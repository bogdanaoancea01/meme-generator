# frozen_string_literal: true

require './lib/services/meme_input'
require './lib/models/meme'

RSpec.describe MemeInput do
    describe '#parse' do
        context 'when the received JSON is empty' do
            let(:body) { {}.to_json } 

            it 'returns nil' do
                result = described_class.new.parse(JSON.parse(body))
                expect(result).to be(nil)
            end
        end

        context 'when the JSON does not describe a meme' do
            let(:body) { { wrong_root: { image_url: "https://picsum.photos/200", text: "MEME description" }}.to_json }

            it 'returns nil' do
                result = described_class.new.parse(JSON.parse(body))

                expect(result).to be(nil)
            end
        end

        context 'when the JSON describes a user' do
            let(:body) { { meme: { image_url: "https://picsum.photos/200", text: "MEME description" }}.to_json }


            it 'returns a user object' do
                result = described_class.new.parse(JSON.parse(body))

                expect(result).to be_a(Meme)

                expect(result.image_url).to eq('https://picsum.photos/200')
                expect(result.text).to eq('MEME description')
            end
        end
    end
end