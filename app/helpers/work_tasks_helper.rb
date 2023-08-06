module WorkTasksHelper
  def subtask_status_bar(task)
    tasks = task.subtasks.to_a
    total_tasks = tasks.size
    return 0 if total_tasks.zero?

    done_tasks = tasks.count { |task| task.done? }
    (done_tasks.to_f / total_tasks * 100).round(2)
  end

  def subtask_status_button_group(status, task)
    classes = "btn"
    (status == task.status) ? classes += " active btn-outline-primary" : classes += " btn-outline-secondary"
    link_to project_work_task_path(@work_task.project, @work_task, "work_task[status]": status), method: :patch, class: classes, data: { confirm: "Are you sure?" } do
      "#{status.titleize}"
    end
  end
end
