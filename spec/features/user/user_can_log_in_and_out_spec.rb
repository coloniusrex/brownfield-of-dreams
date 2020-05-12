require 'rails_helper'

describe 'User' do
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

  it 'user can sign in' do
    user = create(:user)

    visit '/'

    click_on "Sign In"

    expect(current_path).to eq(login_path)

    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password

    click_on 'Log In'

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content(user.email)
    expect(page).to have_content(user.first_name)
    expect(page).to have_content(user.last_name)
  end

  it 'can log out', :js do
    WebMock.allow_net_connect!

    user = create(:user)

    visit login_path

    fill_in'session[email]', with: user.email
    fill_in'session[password]', with: user.password

    click_on 'Log In'

    click_on 'Profile'

    expect(current_path).to eq(dashboard_path)

    click_on 'Log Out'

    expect(current_path).to eq(root_path)
    expect(page).to_not have_content(user.first_name)
    expect(page).to have_content('SIGN IN')

  end

  it 'is shown an error when incorrect info is entered' do
    user = create(:user)
    fake_email = "email@email.com"
    fake_password = "123"

    visit login_path

    fill_in'session[email]', with: fake_email
    fill_in'session[password]', with: fake_password

    click_on 'Log In'

    expect(page).to have_content("Looks like your email or password is invalid")
  end
end
