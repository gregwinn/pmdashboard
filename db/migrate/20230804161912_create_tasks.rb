class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      # parent_id used for subtasks
      t.integer :parent_id

      t.string :title, null: false
      t.string :description
      t.string :work_focus
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
