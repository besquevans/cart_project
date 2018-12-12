class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :sn
      t.string :name
      t.string :address
      t.integer :amount
      t.string :phone
      t.string :shipping_status, default: "not_shipped" 
      t.string :payment_status, default: "not_paid"
      t.timestamps
    end
  end
end
