# frozen_string_literal: true

class PasswordHasher
    def self.hash(password)
        BCrypt::Password.create(password).to_s
    end

    def self.check_hash(hashed_password)
        BCrypt::Password.new(hashed_password)
    end
end