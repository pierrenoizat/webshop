class AddCurrencyToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :currency, :string
  end

  def self.down
    remove_column :products, :currency
  end
end
