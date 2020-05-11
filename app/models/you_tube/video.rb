module YouTube
  class Video
    attr_reader :title, :description, :thumbnail, :id
    attr_accessor :position

    def initialize(data = {})
      @id = data[:id]
      @title = data[:title]
      @description = data[:description]
      @thumbnail = data[:thumbnail][:url]
      @position = data[:position]
    end

    def self.by_id(id)
      new(YoutubeService.new.video_info(id))
    end

    def self.by_playlist_id(playlist_id)
      playlist = YoutubeService.new.playlist_info(playlist_id)
      new_playlist = playlist[:items].map do |item|
          new({video_id: item[:contentDetails][:videoId],
              title: item[:snippet][:title],
              description: item[:snippet][:description],
              position: item[:snippet][:description],
              thumbnail: item[:snippet][:thumbnails][:maxres]})
      end
     end
  end
end
