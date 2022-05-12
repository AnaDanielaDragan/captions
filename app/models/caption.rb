# frozen_string_literal: true

class Caption < ApplicationRecord
  validates :url, presence: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: 'Invalid url format' }
  validates :text, presence: true
end
