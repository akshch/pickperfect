class AddAColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cridets, :float
  end
end
