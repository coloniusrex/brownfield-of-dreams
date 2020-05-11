module YouTube
  class Video
    attr_reader :title, :description, :thumbnail, :id
    attr_accessor :position

    def initialize(data = {})
      @thumbnail = data[:items].first[:snippet][:thumbnails][:high][:url]
      @title = data[:items].first[:snippet][:title]
      @description = data[:items].first[:snippet][:description]
      @id = data[:items].first[:id]
      @position = 0
    end

    def self.by_id(id)
      new(YoutubeService.new.video_info(id))
    end

    def self.by_playlist_id(playlist_id)
      playlist = YoutubeService.new.playlist_info(playlist_id)
      playlist[:items].map do |item|
        video_id = item[:contentDetails][:videoId]
        self.by_id(video_id)
      end
    end
  end
end
