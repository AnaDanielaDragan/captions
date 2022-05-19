# frozen_string_literal: true

class CreateInstagramCaptions < ActiveRecord::Migration[7.0]
  def change
    create_table :instagram_captions do |t|
      t.string :type
      t.string :url
      t.string :text, default: ""
      t.string :caption_url, null: true

      t.timestamps
    end
  end
end
