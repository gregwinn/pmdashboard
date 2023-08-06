module WorkTasksHelper
  def subtask_status_bar(task)
    tasks = task.subtasks.to_a
    total_tasks = tasks.size
    return 0 if total_tasks.zero?

    done_tasks = tasks.count { |task| task.done? }
    (done_tasks.to_f / total_tasks * 100).round(2)
  end
end
