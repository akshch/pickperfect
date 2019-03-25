class AddColumnToSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :submissionid, :string
  end
end
