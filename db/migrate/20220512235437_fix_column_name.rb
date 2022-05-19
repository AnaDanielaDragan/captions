# frozen_string_literal: true

class FixColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :instagram_captions, :type, :content_type
  end
end
