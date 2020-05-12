require 'rails_helper'

describe 'As an admin user' do
  it "I can make a new Tutorial without videos" do

  end

  it "I can make a new Tutorial populated with videos from a YouTube playlist ID" do
    mock_response = File.read('spec/fixtures/youtube/youtube_playlist_item_response.json')
    response = stub_request(:get, "https://www.googleapis.com/youtube/v3/playlistItems?key=#{ENV['YOUTUBE_API_KEY']}&maxResults=50&part=snippet,contentDetails&playlistId=PLCo8A0MAWvYnlbinFxCI-V3ItCUPF0Zui").
         to_return(status: 200, body: mock_response, headers: {})

    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit new_admin_tutorial_path

    fill_in "tutorial[title]", with: "New Title"
    click_on 'Import YouTube Playlist'

    new_tutorial = Tutorial.last
    expect(current_path).to eql(new_admin_tutorial_video_path(new_tutorial))

    fill_in "playlistId", with: "PLCo8A0MAWvYnlbinFxCI-V3ItCUPF0Zui"
    click_on 'Submit'

    expect(current_path).to eql(admin_dashboard_path)
  end

  # xit "" do
  #
  #
  #   expect(current_path).to eql(admin_dashboard_path)
  #   expect(page).to have_content('Tutorial created. View it here.')
  #   click_link 'View it here'
  #
  #   expect(current_path).to eql(tutorial_path(new_tutorial))
  #   expect(page).to have_content(new_tutorial.title)
  # end
end
