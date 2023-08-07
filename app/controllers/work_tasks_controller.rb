class WorkTasksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  def index
  end

  def show
    @work_task = WorkTask.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @work_task }
    end
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

    respond_to do |format|
      if @work_task.save
        if @work_task.has_parent?
          format.html { redirect_to project_work_task_path(@work_task.project, @work_task.parent), notice: "Work task was successfully created." }
          format.json { render json: @work_task, status: :created }
        else
          format.html { redirect_to project_path(@project), notice: "Work task was successfully created." }
          format.json { render json: @work_task, status: :created }
        end
      else
        format.html { render :new, alert: "Work task could not be created." }
        format.json { render json: @work_task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @work_task = WorkTask.find(params[:id])
    authorize! :update, @work_task

    # Only allow the status to be changed if the user is an employee and the task is not overdue
    if (@work_task.can_employee_change_status?(work_task_params[:status]) && current_user.employee?) || current_user.pm?
      respond_to do |format|
        if @work_task.update(work_task_params)
          format.html { redirect_to project_work_task_path(@work_task.project, @work_task), notice: "Task was successfully updated." }
          format.json { render json: @work_task, status: :ok, location: @work_task }
        else
          format.html { render :edit, alert: "Work task could not be updated." }
          format.json { render json: @work_task.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to project_work_task_path(@work_task.project, @work_task), alert: "You cannot change the status of this task to: #{work_task_params[:status].titleize}." }
        format.json { render json: { error: "You cannot change the status of this task to: #{work_task_params[:status].titleize}." }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @work_task = current_user.work_tasks.find(params[:id])
    work_task = @work_task
    @work_task.destroy
    respond_to do |format|
      if work_task.has_parent?
        format.html { redirect_to project_work_task_path(work_task.project, work_task.parent), notice: "Work task was successfully deleted." }
        format.json { head :no_content }
      else
        format.html { redirect_to project_path(@work_task.project), notice: "Work task was successfully deleted." }
        format.json { head :no_content }
      end
    end
  end

  private

  def work_task_params
    params.require(:work_task).permit(:title, :description, :due_date, :status, :work_focus, :user_assignment_id, :parent_id)
  end
end
