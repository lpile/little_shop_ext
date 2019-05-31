class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.boolean :active, default: false
      t.decimal :price
      t.text :description
      t.string :image
      t.integer :inventory

      t.timestamps
    end
  end
end
