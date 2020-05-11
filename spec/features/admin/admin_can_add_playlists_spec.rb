require 'rails_helper'

describe 'As an admin user' do
  it "I can visit new_Admin tutorial and click on Import YouTube playlist" do
    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)


    visit new_admin_tutorial_path
    fill_in "tutorial[title]", with: "New Title"

    click_on 'Import YouTube Playlist'
    # expect(current_path).to eql(new_admin_tutorial_video_path)

    fill_in "playlistId", with: "PLCo8A0MAWvYnlbinFxCI-V3ItCUPF0Zui"
    click_on 'Submit'

    expect(current_path).to eql(admin_dashboard_path)
    expect(page).to have_content('Tutorial created. View it here.')
    click_link 'View it here'

    new_tutorial = Tutorial.last
    expect(current_path).to eql(tutorial_path(new_tutorial))
    expect(page).to have_content(new_tutorial.title)
  end
end
