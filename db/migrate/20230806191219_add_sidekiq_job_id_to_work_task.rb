class AddSidekiqJobIdToWorkTask < ActiveRecord::Migration[7.0]
  def change
    add_column :work_tasks, :sidekiq_job_id, :string
  end
end
