# frozen_string_literal: true

class NotFoundError < StandardError
  def self.body
    {
      error: {
        code: "not_found",
        title: "Requested caption does not exist",
        description: ""
      }
    }
  end
end
