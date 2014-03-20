class AddStatusToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :status, :string
  end

  def self.down
    remove_column :invoices, :status
  end
end
