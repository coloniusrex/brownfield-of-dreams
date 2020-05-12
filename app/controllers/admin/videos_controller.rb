class Admin::VideosController < Admin::BaseController
  def edit
    @video = Video.find(params[:video_id])
  end

  def update
    video = Video.find(params[:id])
    video.update(video_params)
  end

  def new
    @tutorial = Tutorial.find(params[:tutorial_id])
  end

  def create
    begin
      tutorial = Tutorial.find(params[:tutorial_id])
      if params[:playlistId].nil?
        thumbnail = YouTube::Video.by_id(new_video_params[:video_id]).thumbnail
        video = tutorial.videos.new(new_video_params.merge(thumbnail: thumbnail))
        video.save
        flash[:success] = 'Successfully created video.'
        redirect_to edit_admin_tutorial_path(id: tutorial.id)
      elsif params[:video].nil?
        playlist = YouTube::Video.by_playlist_id(params[:playlistId])
        playlist.each do |item|
          tutorial.videos.create({title: item.title,
                                  description: item.description,
                                  thumbnail: item.thumbnail,
                                  video_id: item.id,
                                  position: item.position,
                                  tutorial_id: params[:tutorial_id]})
        end
        flash[:success] = "Tutorial created. #{view_context.link_to 'View it here', tutorial_path(tutorial)}."
        redirect_to admin_dashboard_path
      end
    rescue StandardError
      flash[:error] = 'Unable to create video.'
    end
  end

  private

  def video_params
    params.permit(:position)
  end

  def new_video_params
    params.require(:video).permit(:title, :description, :video_id, :thumbnail, :tag_list)
  end
end
