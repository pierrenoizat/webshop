class AddCityToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :city, :string
  end

  def self.down
    remove_column :invoices, :city
  end
end
