class RenameShoppingStatusInOrders < ActiveRecord::Migration[5.2]
  def change
    rename_column :orders, :shopping_status, :shipping_status
  end
end
