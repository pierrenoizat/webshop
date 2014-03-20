class RemoveInvoiceImageUrl < ActiveRecord::Migration
  def self.up
    remove_column :invoices, :image_url
  end

  def self.down
    add_column :invoices, :image_url
  end
end
