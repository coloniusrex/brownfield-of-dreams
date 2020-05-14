require 'rails_helper'

describe 'A registered user' do
  it 'can add videos to their bookmarks' do
    tutorial= create(:tutorial, title: "How to Tie Your Shoes")
    video = create(:video, title: "The Bunny Ears Technique", tutorial: tutorial)
    user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit tutorial_path(tutorial)

    expect {
      click_on 'Bookmark'
    }.to change { UserVideo.count }.by(1)

    expect(page).to have_content("Bookmark added to your dashboard")
  end

  it "can't add the same bookmark more than once" do
    tutorial= create(:tutorial)
    video = create(:video, tutorial_id: tutorial.id)
    user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit tutorial_path(tutorial)

    click_on 'Bookmark'
    expect(page).to have_content("Bookmark added to your dashboard")
    click_on 'Bookmark'
    expect(page).to have_content("Already in your bookmarks")
  end

  it "I can visit my dashboard and see a list of all bookmarked segments under Bookmarked Segments section" do
    user = create(:user)
    video_1 = create(:video)
    video_2 = create(:video)
    tutorial1 = create(:tutorial)
    tutorial2 = create(:tutorial)
    video_params = {:title=>"Title", :description=>"Describe", :video_id=>"asd234j34j2wdk", :thumbnail=>"asdasasd", :tutorial_id=>tutorial1.id, :position=>1}
    video_params_2 = {:title=>"Title2", :description=>"Describe2", :video_id=>"asd234j23j2wdk", :thumbnail=>"asdsdasd", :tutorial_id=>tutorial1.id, :position=>2}
    video_params_3 = {:title=>"Title3", :description=>"Describe3", :video_id=>"asd234j234j2wd", :thumbnail=>"asdasdsd", :tutorial_id=>tutorial2.id, :position=>1}
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    video1 = user.videos.create(video_params)
    video2 = user.videos.create(video_params_2)
    video3 = user.videos.create(video_params_3)

    visit dashboard_path
    require "pry"; binding.pry
    within "#video-#{video1.id}" do
      expect(page).to have_content(video1.title)
    end
  end
end

# As a logged in user
# When I visit '/dashboard'
# Then I should see a list of all bookmarked segments under the Bookmarked Segments section
# And they should be organized by which tutorial they are a part of
# And the videos should be ordered by their position
