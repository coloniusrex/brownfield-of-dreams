require 'rails_helper'

describe 'As a registered user' do
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
   
    mock_response_invite_has_email = File.read('spec/fixtures/github/github_user_invite.json')
    stub_request(:get, "https://api.github.com/users/SMJ289").
        with(
          headers: {
        'Authorization'=>"token #{ENV['GITHUB_TOKEN']}"
          }).
        to_return(status: 200, body: mock_response_invite_has_email, headers: {})
    
    mock_response_invite_has_no_email = File.read('spec/fixtures/github/github_user_invite_no_email.json')
    stub_request(:get, "https://api.github.com/users/alex-latham").
        with(
        headers: {
        'Authorization'=>"token #{ENV['GITHUB_TOKEN']}"
          }).
        to_return(status: 200, body: mock_response_invite_has_no_email, headers: {})

    @user = create(:user)
    @user.token = ENV['GITHUB_TOKEN']
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it 'from the dashboard I see a link to Send an Invite' do
    visit dashboard_path

    click_link 'Send an Invite'
    expect(current_path).to eq('/invite')
  end

  it 'from the new invite page I see a form to fill in a GitHub handle' do
    visit '/invite'

    fill_in 'GitHub Handle', with: 'SMJ289'
    click_on 'Send an Invite'
    expect(current_path).to eq(dashboard_path)
  end

  it 'when I fill out the invite form with a valid GH username I see success flash message' do
    visit '/invite'
    fill_in 'GitHub Handle', with: 'SMJ289'
    click_on 'Send an Invite'
    expect(page).to have_content("Successfully sent invite!")
    expect(current_path).to eq(dashboard_path)
  end

  it 'when I fill out the invite form with a invalid GH username I see sad flash message and am sent back to the form' do
    visit '/invite'
    fill_in 'GitHub Handle', with: 'alex-latham'
    click_on 'Send an Invite'
    expect(page).to have_content("The GitHub user you selected doesn't have an email address associated with their account.")
    expect(current_path).to eq('/invite')
  end
end