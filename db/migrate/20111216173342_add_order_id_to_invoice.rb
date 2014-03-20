class AddOrderIdToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :order_id, :integer
  end

  def self.down
    remove_column :invoices, :order_id
  end
end
