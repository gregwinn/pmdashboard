module ProjectsHelper
  def project_status_bar(project)
    tasks = project.work_tasks.to_a
    total_tasks = tasks.size
    return 0 if total_tasks.zero?

    done_tasks = tasks.count { |task| task.done? }
    (done_tasks.to_f / total_tasks * 100).round(2)
  end

  def project_status_class(project)
    if project.due_date < Date.today
      "bg-danger"
    elsif project.due_date < Date.today + 7
      "bg-warning"
    end
  end

  def project_status_text(project)
    if project.due_date < Date.today
      "Late"
    elsif project.due_date < Date.today + 7
      "Due Soon"
    end
  end
end
