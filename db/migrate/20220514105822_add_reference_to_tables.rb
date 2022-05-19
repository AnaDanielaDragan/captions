# frozen_string_literal: true

class AddReferenceToTables < ActiveRecord::Migration[7.0]
  def change
    add_reference :tokens, :users
  end
end
