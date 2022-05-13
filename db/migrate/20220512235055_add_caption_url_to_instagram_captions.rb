class AddCaptionUrlToInstagramCaptions < ActiveRecord::Migration[7.0]
  def change
    add_column :instagram_captions, :caption_url, :string, null: true
  end
end
