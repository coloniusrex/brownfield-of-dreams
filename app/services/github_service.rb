class GithubService
  def conn
    Faraday.new(url: 'https://api.github.com') do |faraday|
      faraday.headers['authorization'] = "token #{ENV['GITHUB_TOKEN']}"
    end
  end

  def user_repos
    response = conn.get('/user/repos')
    JSON.parse(response.body, symbolize_names: true)
  end

  def user_info
    user_response = conn.get('/user')
    JSON.parse(user_response.body, symbolize_names: true)
  end

  def user_followers
    followers_response = conn.get('/user/followers')
    JSON.parse(followers_response.body, symbolize_names: true)
  end
end
