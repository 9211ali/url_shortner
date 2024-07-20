class LinksController < ApplicationController

  def index
    @links = Link.recent_first
  end

  def create
    @link = Link.new links_params
    if @link.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

   def links_params
    params.require(:link).permit(:url, :title, :description, :views_count)
   end
end
