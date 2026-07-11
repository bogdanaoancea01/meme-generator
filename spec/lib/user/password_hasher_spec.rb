# frozen_string_literal: true

require './lib/services/password_hasher'

RSpec.describe PasswordHasher do
    describe '.hash' do
        let(:password) {'1234password'}

        it 'returns the hashed password' do
            hashed_password = described_class.hash(password)

            expect(hashed_password).not_to eq(password)
        end

        it 'returns different hashes for the same password' do
            hashed_password_1 = described_class.hash(password)
            hashed_password_2 = described_class.hash(password)

            expect(hashed_password_1).not_to eq(hashed_password_2)
        end
    end

    describe '.check_hash' do
        let(:password) {'1234password'}

        it 'returns the hash for passwords comparisson' do
            hashed_password = described_class.hash(password)

            expect(hashed_password).not_to eq(password)
        end
    end
end