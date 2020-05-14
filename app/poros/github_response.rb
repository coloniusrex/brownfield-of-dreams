class GithubResponse
  def repos(token)
    json = GithubService.new.user_repos(token)
    json.map do |repo_data|
      Repo.new(repo_data)
    end
  end

  def user_name(token)
    json = GithubService.new.user_info(token)
    json[:login]
  end

  def invitee_info(username, token)
    json = GithubService.new.other_user_info(username, token)
  end

  def followers(token)
    json = GithubService.new.user_followers(token)
    json.map do |follower_data|
      Follower.new(follower_data)
    end
  end

  def followees(token)
    json = GithubService.new.user_followees(token)
    json.map do |followee_data|
      Followee.new(followee_data)
    end
  end
end
