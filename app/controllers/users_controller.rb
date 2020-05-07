class UsersController < ApplicationController
  def show
    conn = Faraday.new(url: "https://api.github.com") do |faraday|
      faraday.headers['authorization'] = "token #{ENV["GITHUB_TOKEN"]}"
    end
    response = conn.get('/user/repos')
    user_response = conn.get('/user')
    json = JSON.parse(response.body, symbolize_names: true)
    user_json = JSON.parse(user_response.body, symbolize_names: true)
    @github_username = user_json[:login]
    @repos = json.map do |repo_data|
      Repo.new(repo_data)
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
