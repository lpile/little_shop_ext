class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :nickname, default: 'Home'
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.timestamps
    end
  end
end
