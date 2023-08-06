class CheckTaskJob
  include Sidekiq::Job

  def perform(task_id)
    # Check task to see if its overdue
    task = WorkTask.find(task_id)
    if task.due_date <= Date.today
      task.update(status: 'late')
    end
  end
end
