require 'rails_helper'

describe 'As a logged in user when' do

  before(:each) do
    mock_response = File.read('spec/fixtures/github/github_user_repos_response.json')
    stub_request(:get, "https://api.github.com/user/repos").
    with(
         headers: {'Authorization' => "token #{ENV['GITHUB_TOKEN']}"
           }).
      to_return(status: 200, body: mock_response, headers: {})

    mock_response_user = File.read('spec/fixtures/github/github_user_response.json')
      stub_request(:get, "https://api.github.com/user").
           with(
             headers: {
            'Authorization'=>"token #{ENV['GITHUB_TOKEN']}"
             }).
           to_return(status: 200, body: mock_response_user, headers: {})

    mock_response_followers = File.read('spec/fixtures/github/github_user_followers_response.json')
    stub_request(:get, "https://api.github.com/user/followers").
         with(
           headers: {
          'Authorization'=>"token #{ENV['GITHUB_TOKEN']}"
           }).
         to_return(status: 200, body: mock_response_followers, headers: {})

    mock_response_following = File.read('spec/fixtures/github/github_user_following_response.json')
    stub_request(:get, "https://api.github.com/user/following").
         with(
           headers: {
          'Authorization'=>"token #{ENV['GITHUB_TOKEN']}"
           }).
         to_return(status: 200, body: mock_response_following, headers: {})
  end

  it "I don't see a section for GitHub with a list of 5 repositories and their name as a link to that repo if I don't have a token" do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit '/dashboard'

    expect(page).to have_no_css('.user-github')
  end

  it "I can see a section for GitHub with a list of 5 repositories and their name as a link to that repo when I have a token" do
    user = create(:user)
    user.token = ENV["GITHUB_TOKEN"]

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit '/dashboard'

    within '.user-github' do
      expect(page).to have_content("coloniusrex's GitHub")
      expect(page).to have_no_content("SMJ289's GitHub")

      within '.repos' do
        expect(page).to have_css(".repo", count: 5)
      end
    end
  end

  it "I can see a section within Github section, titled Followers with a list of followers handles as links when I have a token" do
    user = create(:user)
    user.token = ENV["GITHUB_TOKEN"]

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit '/dashboard'

    within '.user-github' do
      expect(page).to have_css('.followers')
    end
  end

  it "I can see a section within Github section, titled Following with a list of users I follow handles as links when I have a token" do
    user = create(:user)
    user.token = ENV["GITHUB_TOKEN"]

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit '/dashboard'
    within '.user-github' do
      expect(page).to have_css('.followees')
    end
  end
end
