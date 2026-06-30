# frozen_string_literal: true

class Response
  attr_reader :response_status, :redirect_url

  def initialize(response_status, redirect_url = nil)
    @response_status = response_status
    @redirect_url = redirect_url
  end
end
