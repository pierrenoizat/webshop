class AddQrcodeStringToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :qrcode_string, :string
  end

  def self.down
    remove_column :orders, :qrcode_string
  end
end
