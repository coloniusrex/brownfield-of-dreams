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
      within '.followers' do
        expect(page).to have_css('.follower')
      end
    end
  end
end


# As a logged in user
# When I visit /dashboard
# Then I should see a section for "Github"
# And under that section I should see another section titled "Followers"
# And I should see list of all followers with their handles linking to their Github profile
