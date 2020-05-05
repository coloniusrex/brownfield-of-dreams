require 'rails_helper'

describe 'visitor visits video show page' do
  it 'clicks on the bookmark button and sees a flash message indicating they need to login' do
    tutorial = create(:tutorial)
    video = create(:video, tutorial_id: tutorial.id)

    visit tutorial_path(tutorial)

    click_on 'Bookmark'
    expect(page).to have_content('You need to login to bookmark videos!')
    expect(current_path).to eq(tutorial_path(tutorial))
  end
end
