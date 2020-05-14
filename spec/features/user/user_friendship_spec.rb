require 'rails_helper'

describe 'As a registered user' do
  before(:each) do

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      "credentials"=>{"token"=>ENV['GITHUB_TOKEN'], "expires"=>false},
      })


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

  describe "I can see a link to add a local friend if that local user has a GitHub acct and follows me/I follow them" do
    it 'and when I click the link in FOLLOWERS I see a flash message and the user in a Local Friend section' do
      user = create(:user)
      user_2 = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      user.token = ENV['GITHUB_TOKEN']
      user.github_id = '57749981'
      user.save
      user_2.github_id = '57697706'
      user_2.save

      visit dashboard_path

      within("#follower-#{user_2.github_id}") do
        expect(page).to have_content('Add Local Friend')
        click_on 'Add Local Friend'
      end

      expect(current_path).to eql(dashboard_path)
      expect(page).to have_content('Added friend!')
      within '.local-friends' do
        expect(page).to have_content("Friend Name: #{user_2.first_name}")
      end
    end

    it "and when I click Add Local Friend for a user I already friended, I see a sad path flash message" do
      user = create(:user)
      user_2 = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      user.token = ENV['GITHUB_TOKEN']
      user.github_id = '57749981'
      user.save
      user_2.github_id = '57697706'
      user_2.save

      visit dashboard_path

      within("#follower-#{user_2.github_id}") do
        expect(page).to have_content('Add Local Friend')
        click_on 'Add Local Friend'
      end

      within("#follower-#{user_2.github_id}") do
        expect(page).to have_content('Add Local Friend')
        click_on 'Add Local Friend'
      end

      expect(current_path).to eql(dashboard_path)
      expect(page).to have_content('User Already friended!')

    end

    it 'and when I click the link in FOLLOWEES I see a flash message and the user in a Local Friend section' do
      user = create(:user)
      user_2 = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      user.token = ENV['GITHUB_TOKEN']
      user.github_id = '57749981'
      user.save
      user_2.github_id = '57697706'
      user_2.save

      visit dashboard_path

      within("#followee-#{user_2.github_id}") do
        click_on 'Add Local Friend'
      end

      expect(current_path).to eql(dashboard_path)
      expect(page).to have_content('Added friend!')
      within '.local-friends' do
        expect(page).to have_content("Friend Name: #{user_2.first_name}")
      end
    end
  end

  it "If my followers/followees don't have a local account there is no link to Add Local Friend" do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    user.token = ENV['GITHUB_TOKEN']
    user.github_id = '57749981'
    user.save

    visit dashboard_path

    within '.followers' do
      expect(page).to have_no_content('Add Local Friend')
    end

    within '.followees' do
      expect(page).to have_no_content('Add Local Friend')
    end
  end
end
