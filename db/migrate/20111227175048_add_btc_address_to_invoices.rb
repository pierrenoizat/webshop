class AddBtcAddressToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :btc_address, :string
  end

  def self.down
    remove_column :invoices, :btc_address
  end
end
