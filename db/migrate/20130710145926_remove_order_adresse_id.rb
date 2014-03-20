class RemoveOrderAdresseId < ActiveRecord::Migration
  def self.up
    remove_column :orders, :adresse_id
  end

  def self.down
    add_column :orders, :adresse_id
  end
end
