class UsersController < ApplicationController
  def show
    if current_user.token.present?
      response = GithubResponse.new
      @repos = response.repos(current_user.token)
      @github_username = response.user_name(current_user.token)
      @github_followers = response.followers(current_user.token)
      @github_followees = response.followees(current_user.token)
    end
  end

  def new
    @user = User.new
  end

  def update
    user_updates = create_friend(params)
    update_handler(user_updates)
    redirect_to dashboard_path
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:success] = "Logged in as #{user.first_name}."
      if user.status == 'inactive'
        flash[:notice] = "This account has not yet been activated. Please check your email."
      end
      redirect_to dashboard_path
    else
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to '/register'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end

  def update_handler(user_updates)
    if user_updates.save
      flash[:success] = 'Added friend!'
    else
      flash[:error] = user_updates.errors.full_messages.to_sentence
    end
  end

  def create_friend(params)
    if params[:gh_follower_id].present?
      follower = User.find_by(github_id: params[:gh_follower_id])
      current_user.followings.new(followed_user_id:follower.id)
    elsif params[:gh_followee_id].present?
      followee = User.find_by(github_id: params[:gh_followee_id])
      current_user.followings.new(followed_user_id:followee.id)
    end
  end
end
