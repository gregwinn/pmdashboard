class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if params[:user][:password].blank?
      @user.update_without_password(user_params)
    else
      @user.update(user_params)
    end
    redirect_to edit_user_path, notice: 'User was successfully updated.'
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
