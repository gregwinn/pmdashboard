class WorkTasksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  def index
  end

  def show
    @work_task = WorkTask.find(params[:id])
  end

  def edit
    @work_task = WorkTask.find(params[:id])
    @parent_task = params[:parent_id].present? ? @work_task.parent : nil
  end

  def new
    @project = Project.find(params[:project_id])
    @parent_task = params[:parent_id].present? ? @project.work_tasks.find(params[:parent_id]) : nil
    @work_task = @project.work_tasks.new(parent: @parent_task)
  end

  def create
    @project = Project.find(params[:project_id])
    @work_task = @project.work_tasks.new(work_task_params)
    @work_task.user = current_user
    if @work_task.save

      # Create a delayed job to check if the task is overdue
      CheckTaskJob.perform_at(@work_task.due_date.to_time.to_i, @work_task.id)

      if @work_task.has_parent?
        redirect_to project_work_task_path(@work_task.project, @work_task.parent), notice: "Work task was successfully created."
      else
        redirect_to project_path(@project), notice: "Work task was successfully created."
      end
    else
      puts @work_task.errors.full_messages
      render :new, alert: "Work task could not be created."
    end
  end

  def update
    @work_task = current_user.work_tasks.find(params[:id])
    authorize! :update, @work_task

    if @work_task.due_date != work_task_params[:due_date]
      # Delete the old delayed job
      remove_sidekiq_job(@work_task)
    end

    if @work_task.update(work_task_params)
      # Create a delayed job to check if the task is overdue
      CheckTaskJob.perform_at(@work_task.due_date.to_time.to_i, @work_task.id)

      redirect_to(project_work_task_path(@work_task.project, @work_task), notice: "Task was successfully updated.")
    else
      render :edit, alert: "Work task could not be updated."
    end
  end

  def destroy
    @work_task = current_user.work_tasks.find(params[:id])
    work_task = @work_task
    @work_task.destroy
    if work_task.has_parent?
      redirect_to project_work_task_path(work_task.project, work_task.parent), notice: "Work task was successfully deleted."
    else
      redirect_to project_path(@work_task.project), notice: "Work task was successfully deleted."
    end
  end

  private

  def remove_sidekiq_job(work_task)
    jobs = Sidekiq::ScheduledSet.new
    jobs.each do |job|
      if job.jid == work_task.sidekiq_job_id
        job.delete
      end
    end
  end

  def work_task_params
    params.require(:work_task).permit(:title, :description, :due_date, :status, :work_focus, :user_assignment_id, :parent_id)
  end
end
