# frozen_string_literal: true

require './lib/services/json_parser_service'
require './lib/dtos/meme'

RSpec.describe JsonParserService do
  describe '#parse' do
    context 'when the received JSON is empty' do
      let(:body) { File.read('spec/fixtures/empty_json_test.json') }

      it 'returns nil' do
        result = described_class.new.parse(body, 'meme')
        expect(result).to be(nil)
      end
    end

    context 'when the JSON root does not describe a meme' do
      let(:body) { File.read('spec/fixtures/different_root_test.json') }

      it 'returns nil' do
        result = described_class.new.parse(body, 'meme')
        expect(result).to be(nil)
      end
    end

    context 'when the JSON describes a meme' do
      let(:body) { File.read('spec/fixtures/meme_test.json') }

      it 'returns a meme object' do
        result = described_class.new.parse(JSON.parse(body), 'meme')

        expect(result).to be_a(Meme)

        expect(result.image_url).to eq('https://picsum.photos/200')
        expect(result.text).to eq('MEME description')
      end
    end

    context 'when the JSON describes a meme without image link' do
      let(:body) { File.read('spec/fixtures/no_link_test.json') }

      it 'returns a meme object' do
        result = described_class.new.parse(JSON.parse(body), 'meme')

        expect(result).to be_a(Meme)

        expect(result.image_url).to be(nil)
        expect(result.text).to eq('Generate description')
      end
    end

    context 'when the JSON describes a user' do
      let(:body) { File.read('spec/fixtures/user/user_test.json') }

      it 'returns a user object' do
        result = described_class.new.parse(JSON.parse(body), 'user')

        expect(result).to be_a(User)

        expect(result.username).to eq('mr_bean')
        expect(result.password).to eq('test123')
      end
    end
  end
end
