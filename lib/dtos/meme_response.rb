# frozen_string_literal: true

class MemeResponse
  attr_reader :message, :redirect_url

  def initialize(message: nil, redirect_url: nil)
    @message = message
    @redirect_url = redirect_url
  end
end
