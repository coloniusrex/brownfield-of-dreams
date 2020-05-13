class Admin::TutorialsController < Admin::BaseController
  def edit
    @tutorial = Tutorial.find(params[:id])
  end

  def create
    @tutorial = Tutorial.new(tutorial_params)
    if @tutorial.save
      redirect_or_import(@tutorial)
    else
      flash[:error] = @tutorial.errors.full_messages.to_sentence
      redirect_to new_admin_tutorial_path
    end
  end

  def new
    @tutorial = Tutorial.new
  end

  def update
    tutorial = Tutorial.find(params[:id])
    if tutorial.update(tutorial_params)
      flash[:success] = "#{tutorial.title} tagged!"
    end
    redirect_to edit_admin_tutorial_path(tutorial)
  end

  def destroy
    tutorial = Tutorial.find(params[:id])
    flash[:success] = "#{tutorial.title} tagged!" if tutorial.destroy
    redirect_to admin_dashboard_path
  end

  private

  def tutorial_params
    params.require(:tutorial).permit(:title,
                                     :description,
                                     :thumbnail,
                                     :tag_list)
  end

  def redirect_or_import(tutorial)
    if params[:commit] == 'Create Tutorial'
      flash[:success] = "Tutorial succesfully created."
      redirect_to admin_dashboard_path
    elsif params[:commit] == 'Import YouTube Playlist'
      redirect_to new_admin_tutorial_video_path(tutorial.id)
    end
  end
end
