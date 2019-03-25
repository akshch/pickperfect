class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :name
      t.string :location
      t.datetime :expiry
      t.text :description
      t.float :credits_required
      t.boolean :published
      t.integer :submission

      t.timestamps
    end
  end
end
