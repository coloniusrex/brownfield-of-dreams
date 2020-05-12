class YoutubeService
  def video_info(id)
    params = { part: 'snippet,contentDetails,statistics', id: id }

    json = get_json('youtube/v3/videos', params)

    data =
      {
        id: id,
        title: json[:items].first[:snippet][:title],
        description: json[:items].first[:snippet][:description],
        thumbnail: json[:items].first[:snippet][:thumbnails][:standard][:url]
      }
  end

  def playlist_info(id)
    params = { part: 'snippet,contentDetails', playlistId: id, maxResults: 50 }

    json = get_json('youtube/v3/playlistItems', params)
    new_json = {}
    if json[:nextPageToken].present?
      new_json[:nextPageToken] = json[:nextPageToken]
      until new_json[:nextPageToken].nil?
        params[:pageToken] = json[:nextPageToken]
        new_json = get_json('youtube/v3/playlistItems', params)
        json[:nextPageToken] = new_json[:nextPageToken]

        new_json[:items].each do |item|
          json[:items] << item
        end
      end
    end
    json
  end

  private

  def get_json(url, params)
    response = conn.get(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: 'https://www.googleapis.com') do |f|
      f.adapter Faraday.default_adapter
      f.params[:key] = ENV['YOUTUBE_API_KEY']
    end
  end
end
