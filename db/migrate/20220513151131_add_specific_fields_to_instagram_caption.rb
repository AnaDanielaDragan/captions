# frozen_string_literal: true

class AddSpecificFieldsToInstagramCaption < ActiveRecord::Migration[7.0]
  def change
    add_column :instagram_captions, :filter, :string
    add_column :instagram_captions, :color, :string
    add_column :instagram_captions, :start_color, :string
    add_column :instagram_captions, :end_color, :string
  end
end
