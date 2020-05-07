require 'rails_helper'

describe 'As a logged in user when' do
  it "I can see a section for GitHub with a list of 5 repositories and their name as a link to that repo" do
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

# As a logged in user
# When I visit /dashboard
# Then I should see a section for "Github"
# And under that section I should see a list of 5 repositories with the name of each Repo linking to the repo on Github
