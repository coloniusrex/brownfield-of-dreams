class Followee
  attr_reader :username,
              :html_url,
              :github_id
  def initialize(attributes)
    @username = attributes[:login]
    @html_url = attributes[:html_url]
    @github_id = attributes[:id]
  end

  def has_account?
    @user = User.find_by(github_id:self.github_id.to_s)
    @user.present?
  end
end
