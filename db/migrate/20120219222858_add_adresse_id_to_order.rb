class AddAdresseIdToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :adresse_id, :integer
  end

  def self.down
    remove_column :orders, :adresse_id
  end
end
