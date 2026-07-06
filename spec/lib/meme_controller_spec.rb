# frozen_string_literal: true

require './lib/controllers/meme_controller'

RSpec.describe MemeController do
  describe '#execute' do
    context 'when the JSON request is valid' do
      let(:body) { File.read('spec/fixtures/meme_test.json') }
      let(:img_path) { 'spec/fixtures/test_original_1.png' }
      let(:img_path_generated) { 'test_generated_1.png' }

      it 'returns the generated image name' do
        allow(ImageDownloadService).to receive(:download).and_return(img_path)
        allow(MemeGeneratorService).to receive(:generate).and_return(img_path_generated)

        result = described_class.new.execute(JSON.parse(body))

        expect(result.redirect_url).to eq('test_generated_1.png')
      end
    end

    context 'when the request is empty' do
      let(:body) { File.read('spec/fixtures/empty_json_test.json') }

      it 'returns empty body error message' do
        result = described_class.new.execute(JSON.parse(body))

        expect(result.message).to be('Empty body')
      end
    end

    context 'when the image URL is missing from the request' do
      let(:body) { File.read('spec/fixtures/no_link_test.json') }

      it 'returns check URL field message' do
        result = described_class.new.execute(JSON.parse(body))

        expect(result.message).to eq('Check URL field')
      end
    end

    context 'when the text is missing from the request' do
      let(:body) { File.read('spec/fixtures/no_text_test.json') }

      it 'returns check text field message' do
        result = described_class.new.execute(JSON.parse(body))

        expect(result.message).to eq('Check text field')
      end
    end

    context 'when the image download fails' do
      let(:body) { File.read('spec/fixtures/wrong_url_test.json') }

      it 'returns failed to download immage message' do
        allow(ImageDownloadService).to receive(:download).and_return(nil)

        result = described_class.new.execute(JSON.parse(body))

        expect(result.message).to eq('Failed to download image')
      end
    end
  end
end
