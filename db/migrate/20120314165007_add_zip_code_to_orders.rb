class AddZipCodeToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :zip_code, :string
  end

  def self.down
    remove_column :orders, :zip_code
  end
end
