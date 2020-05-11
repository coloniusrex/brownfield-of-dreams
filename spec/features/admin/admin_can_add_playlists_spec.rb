require 'rails_helper'

describe 'As an admin user' do
  scenario "I can visit new_Admin tutorial and click on Import YouTube playlist" do

    # json_response = File.read('spec/fixtures/youtube/youtube_playlist_item_response.json')
    # stub_request(:get, "https://www.googleapis.com/youtube/").
    #   with(
    #      headers: {
    #     'Accept'=>'*/*',
    #     'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    #     'User-Agent'=>'Faraday v1.0.1'
    #      }).
    #      to_return(status: 200, body: json_response)


    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)


    visit new_admin_tutorial_path
    fill_in "tutorial[title]", with: "New Title"

    click_on 'Import YouTube Playlist'
    # expect(current_path).to eql(new_admin_tutorial_video_path)

    fill_in "playlistId", with: "PLCo8A0MAWvYnlbinFxCI-V3ItCUPF0Zui"
    click_on 'Submit'

    expect(current_path).to eql(admin_dashboard_path)

    click_on 'New Title'

  end
end
