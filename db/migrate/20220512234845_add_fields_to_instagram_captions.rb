class AddFieldsToInstagramCaptions < ActiveRecord::Migration[7.0]
  def change
    add_column :instagram_captions, :type, :string
    add_column :instagram_captions, :url, :string
    add_column :instagram_captions, :text, :string, default: ""
  end
end
