require 'rails_helper'

describe 'As an admin user' do
  it "I can make a new Tutorial without videos" do

  end

  it "I can make a new Tutorial populated with videos from a YouTube playlist ID" do
    mock_response = File.read('spec/fixtures/youtube/youtube_playlist_item_response.json')
    stub_request(:get, "https://www.googleapis.com/youtube/v3/playlistItems?key=#{ENV['YOUTUBE_API_KEY']}&maxResults=50&part=snippet,contentDetails&playlistId=PLCo8A0MAWvYnlbinFxCI-V3ItCUPF0Zui").
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

  it "I can make a new Tutorial populated with videos from a YouTube playlist ID that has more than 50 videos" do
    mock_response_page_1 = File.read('spec/fixtures/youtube/youtube_playlist_pagination_response_p1.json')
    stub_request(:get, "https://www.googleapis.com/youtube/v3/playlistItems?key=#{ENV['YOUTUBE_API_KEY']}&maxResults=50&part=snippet,contentDetails&playlistId=PLDIoUOhQQPlXr63I_vwF9GD8sAKh77dWU").
        to_return(status: 200, body: mock_response_page_1, headers: {})

    mock_response_page_2 = File.read('spec/fixtures/youtube/youtube_playlist_pagination_response_p2.json')
    stub_request(:get, "https://www.googleapis.com/youtube/v3/playlistItems?key=#{ENV['YOUTUBE_API_KEY']}&maxResults=50&part=snippet,contentDetails&playlistId=PLDIoUOhQQPlXr63I_vwF9GD8sAKh77dWU&pageToken=CDIQAA").
        to_return(status: 200, body: mock_response_page_2, headers: {})
    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
        
    visit new_admin_tutorial_path
        
    fill_in "tutorial[title]", with: "New Title"
    click_on 'Import YouTube Playlist'

    new_tutorial = Tutorial.last
    
    expect(current_path).to eql(new_admin_tutorial_video_path(new_tutorial))

    fill_in "playlistId", with: "PLDIoUOhQQPlXr63I_vwF9GD8sAKh77dWU"
    click_on 'Submit'
    new_tutorial = Tutorial.last
    expect(new_tutorial.videos.length).to eq(100)
    expect(current_path).to eql(admin_dashboard_path)
    
    click_on new_tutorial.title
    expect(page).to have_content(new_tutorial.videos.first.title)
    expect(page).to have_content(new_tutorial.videos.last.title)
  end
end
