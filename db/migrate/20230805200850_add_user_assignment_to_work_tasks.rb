class AddUserAssignmentToWorkTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :work_tasks, :user_assignment_id, :integer, null: true, foreign_key: true
  end
end
