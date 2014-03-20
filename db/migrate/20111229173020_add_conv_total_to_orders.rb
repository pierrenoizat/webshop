class AddConvTotalToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :conv_total, :decimal
  end

  def self.down
    remove_column :orders, :conv_total
  end
end
