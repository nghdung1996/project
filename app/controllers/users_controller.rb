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
      log_in user
      flash[:success] = t "welcome_to_the_sample_app"
      redirect_to user
    else
      render :new
    end
  end

  def edit
    @user = User.find_by id: params[:id]

    return if user
    flash[:success] = t "failed_user"
    redirect_to root_path
  end

  def update
    @user = User.find_by id: params[:id]
    if user.update_attributes user_params
      flash[:success] = t "profile_updated"
      redirect_to user
    else
      render :edit
    end
  end

  def index
    @users = User.paginate page: params[:page]
  end

  def destroy
    @user = User.find_by id: params[:id]
    user.destroy
    flash[:success] = t "user_deleted"
    redirect_to users_url
  end

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: :destroy

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :age
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "pleased_log_in"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_path unless current_user? user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
