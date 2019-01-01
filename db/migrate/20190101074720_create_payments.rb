class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.integer :order_id
      t.integer :sn, null:false 
      t.integer :amount
      t.string :payment_method
      t.datetime :paid_at
      t.text :params
      t.timestamps
    end
  end
end
