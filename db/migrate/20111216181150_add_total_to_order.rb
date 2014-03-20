class AddTotalToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :total, :decimal
  end

  def self.down
    remove_column :orders, :total
  end
end
