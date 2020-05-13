class UsersController < ApplicationController
  def show
    if current_user.token.present?
      response = GithubResponse.new
      @repos = response.repos(current_user.token)
      @github_username = response.user_name(current_user.token)
      @followers = response.followers(current_user.token)
      @followees = response.followees(current_user.token)
    end
  end

  def new
    @user = User.new
  end

  def create
    user = User.create(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:error] = 'Username already exists'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end
end
