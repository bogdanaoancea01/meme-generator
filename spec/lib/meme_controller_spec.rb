# frozen_string_literal: true

require './lib/controllers/meme_controller'

RSpec.describe MemeController do
  describe '#execute' do
    it 'returns the response status and image url' do
      result = described_class.new.execute

      expect(result.response_status).to eq(303)
      expect(result.redirect_url).to eq('https://picsum.photos/200')
    end
  end
end
