class AddAColumnToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :response_id, :string
  end
end
