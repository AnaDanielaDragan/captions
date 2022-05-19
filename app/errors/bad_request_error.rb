# frozen_string_literal: true

class BadRequestError < StandardError
  def self.body
    {
      error: {
        code: "bad_request",
        title: "Invalid request body",
        description: ""
      }
    }
  end
end
