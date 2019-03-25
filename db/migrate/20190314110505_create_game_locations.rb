class CreateGameLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :game_locations do |t|
      t.references :game, foreign_key: true
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
