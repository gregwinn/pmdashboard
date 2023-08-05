class ProjectsController < ApplicationController
  before_action :authenticate_user!
  def index
    @projects = Project.all.order(due_date: :asc).includes(:work_tasks)
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(project_params)

    respond_to do |format|
      if @project.save
        puts @project.inspect
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        puts @project.errors.inspect
        format.html { render :new, alert: 'Failed to create project.' }
        format.json { render json: @project, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit, alert: 'Failed to update project.'
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private
    def project_params
      params.require(:project).permit(:title, :description, :due_date)
    end
end
