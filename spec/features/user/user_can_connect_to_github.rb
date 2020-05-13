require 'rails_helper'

describe 'A registered user' do

  xit 'I can click a button to connect my GitHub account using OAuth' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      :provider => 'github',
      :uid => '50503353',
      "credentials"=>{"token"=>ENV['GITHUB_TOKEN'], "expires"=>false},
      })

    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    
    visit dashboard_path

    visit 'https://github.com/login/oauth/authorize?client_id=c128061a3e7a9030b099&scope=repo'

  end
end