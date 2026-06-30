# frozen_string_literal: true

require './lib/controllers/meme_controller'

RSpec.describe MemeController do
  describe '#execute' do
    context 'it recieves an image from the service' do
        let(:img_path) {'images/test.jpg'}

        it 'returns response status 303 and image url' do
        allow(ImageDownloadService).to receive(:download).and_return(img_path)

        result = described_class.new.execute

        expect(result.response_status).to eq(303)
        expect(result.redirect_url).to eq('https://picsum.photos/200')
        end
    end

    context 'service failed - no downloaded image' do 
        let(:img_path) { nil }

        it 'returns response status 400 and nil' do
            allow(ImageDownloadService).to receive(:download).and_return(img_path)

            result = described_class.new.execute

            expect(result.response_status).to eq(400)
            expect(result.redirect_url).to be(nil)
        end
    end
  end
end
