class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.string :name
      t.decimal :montant
      t.string :adresse
      t.string :email
      t.string :contenu

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
