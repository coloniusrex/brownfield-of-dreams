class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:error] = 'Looks like your email or password is invalid'
      render :new
    end
  end

  def update
    oauth_response = request.env['omniauth.auth']
    token = oauth_response["credentials"]["token"]
    github_id = oauth_response[:uid]
    assign_token(token)
    assign_github_id(github_id)
    redirect_to dashboard_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def assign_github_id(github_id)
    current_user.update(github_id: github_id)
  end

  def assign_token(token)
    current_user.update(token: token)
  end

end
