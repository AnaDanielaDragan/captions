# frozen_string_literal: true

class MissingParametersError < StandardError
  def self.body
    {
      error: {
        code: "missing_parameters",
        title: "Parameter is missing from the request body",
        description: ""
      }
    }
  end
end
