class RenameShippingStatusInOrders < ActiveRecord::Migration[5.2]
  def change
    rename_column :orders, :shipping_status, :shopping_status
  end
end
