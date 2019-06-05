class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.integer :qualifier
      t.decimal :percentage
      t.timestamps
    end
    add_reference(:discounts, :merchant, foreign_key: {to_table: :users})
  end
end
