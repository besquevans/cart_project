class AddOnSoldToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :on_sold, :boolean, default: true
  end
end
