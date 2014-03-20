class AddCountryToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :country, :string
  end

  def self.down
    remove_column :invoices, :country
  end
end
