class AddContentToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :content, :string
  end

  def self.down
    remove_column :orders, :content
  end
end
