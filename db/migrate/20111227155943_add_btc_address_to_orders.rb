class AddBtcAddressToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :btc_address, :string
  end

  def self.down
    remove_column :orders, :btc_address
  end
end
