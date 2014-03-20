class AddImageUrlToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :image_url, :string
  end

  def self.down
    remove_column :invoices, :image_url
  end
end
