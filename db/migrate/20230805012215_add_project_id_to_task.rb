class AddProjectIdToTask < ActiveRecord::Migration[7.0]
  def change
    add_reference :work_tasks, :project, null: false, foreign_key: true
  end
end
