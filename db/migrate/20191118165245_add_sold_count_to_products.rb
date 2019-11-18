class AddSoldCountToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :sold_count, :integer, default: 0
  end
end
