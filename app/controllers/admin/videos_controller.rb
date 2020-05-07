class Admin::VideosController < Admin::BaseController
  def edit
    @video = Video.find(params[:video_id])
  end

  def update
    video = Video.find(params[:id])
    video.update(video_params)
  end

  def create
    begin
      tutorial = Tutorial.find(params[:tutorial_id])
      thumbnail = YouTube::Video.by_id(new_video_params[:video_id]).thumbnail
      video = tutorial.videos.new(new_video_params.merge(thumbnail: thumbnail))

      video.save

      flash[:success] = 'Successfully created video.'
    rescue StandardError
      flash[:error] = 'Unable to create video.'
    end

    redirect_to edit_admin_tutorial_path(id: tutorial.id)
  end

  private

  def video_params
    params.permit(:position)
  end

  def new_video_params
    params.require(:video).permit(:title, :description, :video_id, :thumbnail)
  end
end
