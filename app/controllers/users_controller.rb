class UsersController < ApplicationController
  attr_reader :user

  def show
    @user = User.find_by id: params[:id]

    return if user
    flash[:success] = t "failed_user"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if user.save
      flash[:success] = t "welcome_to_the_sample_app"
      redirect_to user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :age
  end
end
