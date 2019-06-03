class AddShipAddressIdToUsersOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :ship_location_id, :integer
    add_column :orders, :ship_location_id, :integer
  end
end
