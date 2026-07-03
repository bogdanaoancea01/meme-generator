# frozen_string_literal: true

require './lib/services/image_download_service'

RSpec.describe ImageDownloadService do
  describe '.download' do
    context 'the given url exists / is correct' do
      let(:url) { 'https://picsum.photos/200' }

      it 'downloads an image and saves it to images folder, returning the path' do
        file_path = described_class.download(url)

        expect(File.exist?(file_path)).to be true
        File.delete(file_path)
      end
    end

    context 'invalid / non-existing url' do
      let(:url) { 'https://picsum.photos/200dddddddddd' }

      it 'catches an error and returns nil' do
        response = described_class.download(url)

        expect(response).to be(nil)
      end
    end
  end
end
