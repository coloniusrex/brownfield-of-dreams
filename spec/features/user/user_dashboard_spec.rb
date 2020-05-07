require 'rails_helper'

describe 'As a logged in user when' do
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
      expect(page).to have_css(".repo", count: 5)
      expect(page).to have_no_content("SMJ289's GitHub")
    end
  end

end
