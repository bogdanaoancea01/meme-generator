# frozen_string_literal: true

class Response
  attr_reader :response_status, :message, :redirect_url

  def initialize(response_status, message = nil, redirect_url = nil)
    @response_status = response_status
    @message = message
    @redirect_url = redirect_url
  end
end
