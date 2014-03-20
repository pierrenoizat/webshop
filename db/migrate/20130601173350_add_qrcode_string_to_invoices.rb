class AddQrcodeStringToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :qrcode_string, :string
  end

  def self.down
    remove_column :invoices, :qrcode_string
  end
end
