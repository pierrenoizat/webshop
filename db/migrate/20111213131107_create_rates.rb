class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
      t.decimal :valeur
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :rates
  end
end
