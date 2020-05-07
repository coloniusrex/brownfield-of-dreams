class GithubResponse
  def repos
    json = GithubService.new.user_repos
    json.map do |repo_data|
      Repo.new(repo_data)
    end
  end

  def user_name
    json = GithubService.new.user_info
    json[:login]
  end
end
