class AddPayTypeToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :pay_type, :string
  end

  def self.down
    remove_column :invoices, :pay_type
  end
end
