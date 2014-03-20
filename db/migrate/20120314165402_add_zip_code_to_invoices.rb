class AddZipCodeToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :zip_code, :string
  end

  def self.down
    remove_column :invoices, :zip_code
  end
end
