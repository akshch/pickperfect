class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :question_id
      t.integer :answer_id

      t.timestamps
    end
  end
end
