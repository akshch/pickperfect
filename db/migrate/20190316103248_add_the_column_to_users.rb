class AddTheColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :bank_address, :string
    add_column :users, :bank_name, :string
    add_column :users, :bank_ifsc, :string
    add_column :users, :routing_number, :integer
  end
end
