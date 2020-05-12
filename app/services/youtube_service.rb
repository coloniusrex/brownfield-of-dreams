class YoutubeService
  def video_info(id)
    params = { part: 'snippet,contentDetails,statistics', id: id }

    json = get_json('youtube/v3/videos', params)

    data = {id: id, title: json[:items].first[:snippet][:title],
      description: json[:items].first[:snippet][:description],
      thumbnail: json[:items].first[:snippet][:thumbnails][:standard][:url]}
  end

  def playlist_info(id)
    params = { part: 'snippet,contentDetails', playlistId: id, maxResults: 50 }

    json = get_json('youtube/v3/playlistItems', params)
    require "pry"; binding.pry
    # check JSON for nextPageToken or items/page comparison

    # check for valid nextPageToken
      # if yes
        # store current json[:items] into paginated_json[:items], send new request
        # do until totalResults == paginated_json[:items].count
        # return paginated_json
      # elsif no
        # return json
      # end

    # check for totalResults > itemsPerPage
      # if yes
        # store current request data, send new request
        # do until totalResults == paginated_items
      # elsif no
        # return json
      # end



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
