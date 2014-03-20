class AddCountryToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :country, :string
  end

  def self.down
    remove_column :orders, :country
  end
end
