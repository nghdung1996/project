class SessionsController < ApplicationController
  attr_reader :user

  def new; end

  def create
    @user = User.find_by email: params_session[:email].downcase
    if user && user.authenticate(params_session[:password])
      log_in_success
    else
      log_in_failed
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def log_in_failed
    flash.now[:danger] = t "invalid_email_password_combination"
    render :new
  end

  def log_in_success
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end
end
