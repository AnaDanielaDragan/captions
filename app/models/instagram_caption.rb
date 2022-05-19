# frozen_string_literal: true

class InstagramCaption < ApplicationRecord
  validates :content_type, presence: true
  validates :url, presence: true, if: -> { content_type == 'image' }
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: 'Invalid url format' }, allow_blank: true
  validates :text, presence: true

  FILTERS = %w[blackwhite light_blur hard_blur].freeze

  validates :filter, inclusion: FILTERS, if: -> { content_type == 'image' }, allow_blank: true
  validates :color, presence: true, if: -> { content_type == 'color' }
  validates :start_color, :end_color, presence: true, if: -> { content_type == 'gradient' }
end
