class AddFirstCategoryToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :first_category, :string
  end

  def self.down
    remove_column :products, :first_category
  end
end
