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

    # Create a delayed job to check if the task is overdue
    @work_task.sidekiq_job_id = CheckTaskJob.perform_at(@work_task.due_date.to_time.to_i, @work_task.id)

    if @work_task.save

      if @work_task.has_parent?
        redirect_to project_work_task_path(@work_task.project, @work_task.parent), notice: "Work task was successfully created."
      else
        redirect_to project_path(@project), notice: "Work task was successfully created."
      end
    else
      remove_sidekiq_job(@work_task)
      render :new, alert: "Work task could not be created."
    end
  end

  def update
    @work_task = WorkTask.find(params[:id])
    authorize! :update, @work_task

    if @work_task.due_date != work_task_params[:due_date]
      # Delete the old delayed job
      remove_sidekiq_job(@work_task)

      # Create a delayed job to check if the task is overdue
      @work_task.sidekiq_job_id = CheckTaskJob.perform_at(@work_task.due_date.to_time.to_i, @work_task.id)
    end

    # Only allow the status to be changed if the user is an employee and the task is not overdue
    if (@work_task.can_employee_change_status?(work_task_params[:status]) && current_user.employee?) || current_user.pm?

      respond_to do |format|
        if @work_task.update(work_task_params)

          format.html { redirect_to project_work_task_path(@work_task.project, @work_task), notice: "Task was successfully updated." }
          format.json { render :show, status: :ok, location: @work_task }
          format.js
        else
          format.html { render :edit, alert: "Work task could not be updated." }
          format.json { render json: @work_task.errors, status: :unprocessable_entity }
          format.js
        end
      end
    else
      redirect_to project_work_task_path(@work_task.project, @work_task), alert: "You cannot change the status of this task to: #{work_task_params[:status].titleize}."
    end

  end

  def destroy
    @work_task = current_user.work_tasks.find(params[:id])
    work_task = @work_task
    @work_task.destroy
    remove_sidekiq_job(work_task)
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
