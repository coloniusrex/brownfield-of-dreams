require 'rails_helper'

describe 'A registered user' do
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

  it 'I can click a button to connect my GitHub account using OAuth' do
    # WebMock.allow_net_connect!
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      "credentials"=>{"token"=>ENV['GITHUB_TOKEN'], "expires"=>false},
      })

    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    
    visit dashboard_path

    visit '/auth/github'
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("coloniusrex's GitHub")
  end
end