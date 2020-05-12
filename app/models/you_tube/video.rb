module YouTube
  class Video
    attr_reader :title, :description, :thumbnail, :id
    attr_accessor :position

    def initialize(data = {})
      @id = data[:id]
      @title = data[:title]
      @description = data[:description]
      @thumbnail = data[:thumbnail]
      @position = data[:position]
    end

    def self.by_id(id)
      new(YoutubeService.new.video_info(id))
    end

    def self.by_playlist_id(playlist_id)
      playlist = YoutubeService.new.playlist_info(playlist_id)
      playlist[:items].map do |item|
          new({id: item[:contentDetails][:videoId],
              title: item[:snippet][:title],
              description: item[:snippet][:description],
              position: item[:snippet][:position],
              thumbnail: item[:snippet][:thumbnails][:standard][:url] })
      end
     end
  end
end
