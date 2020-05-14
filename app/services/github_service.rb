class GithubService
  def conn(token)
    Faraday.new(url: 'https://api.github.com') do |faraday|
      faraday.headers['authorization'] = "token #{token}"
    end
  end

  def user_repos(token)
    response = conn(token).get('/user/repos')
    JSON.parse(response.body, symbolize_names: true)
  end

  def user_info(token)
    user_response = conn(token).get('/user')
    JSON.parse(user_response.body, symbolize_names: true)
  end

  def other_user_info(username, token)
    user_response = conn(token).get("/users/#{username}")
    JSON.parse(user_response.body, symbolize_names: true)
  end

  def user_followers(token)
    followers_response = conn(token).get('/user/followers')
    JSON.parse(followers_response.body, symbolize_names: true)
  end

  def user_followees(token)
    followees_response = conn(token).get('/user/following')
    JSON.parse(followees_response.body, symbolize_names: true)
  end
end
