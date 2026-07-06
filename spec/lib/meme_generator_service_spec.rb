# frozen_string_literal: true

require './lib/services/meme_generator_service'

RSpec.describe MemeGeneratorService do
  describe '.generate' do
    context 'when generate methos is called' do
      let(:img_path) { 'spec/fixtures/test_original_1.png' }
      let(:img_text) { 'Text for Test' }
      let(:generated_img_path) { 'spec/fixtures/test_generated_1.png' }

      it 'creates a new image (file)' do
        file_path = described_class.generate(img_path, img_text)

        expect(file_path).to eq(generated_img_path)

        expect(File).to exist(file_path)
        File.delete(file_path)
      end
    end
  end
end
