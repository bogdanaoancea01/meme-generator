# frozen_string_literal: true

class AuthResponse
  attr_reader :outcome, :errors, :token

  def initialize(outcome:, errors: nil, token: nil)
    @outcome = outcome
    @errors = errors
    @token = token
  end
end