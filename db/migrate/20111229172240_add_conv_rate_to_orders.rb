class AddConvRateToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :conv_rate, :decimal
  end

  def self.down
    remove_column :orders, :conv_rate
  end
end
