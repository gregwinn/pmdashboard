class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if params[:user][:password].blank?
      success = @user.update_without_password(user_params)
    else
      success = @user.update(user_params)
    end
    respond_to do |format|
      if success
        format.html { redirect_to edit_user_path, notice: 'User was successfully updated.' }
        format.json { render json: @user, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def tasks
    @work_tasks = current_user.assigned_tasks
    respond_to do |format|
      format.html # tasks.html.erb
      format.json { render json: @work_task }
    end
  end

  def projects
    respond_to do |format|
      format.html # projects.html.erb
      format.json { render json: current_user.projects }
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
