class AddPhotoUrlToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :photo_url, :string
  end

  def self.down
    remove_column :products, :photo_url
  end
end
