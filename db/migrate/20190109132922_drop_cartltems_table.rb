class DropCartltemsTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :cartltems
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
