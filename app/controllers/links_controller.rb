class LinksController < ApplicationController

  before_action :set_link, only: [ :show, :edit, :update, :destroy ]
  
  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_path, notice: "Couldn't find the link to the application"
  end

  def new
    @link = Link.new
  end

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

  def show
  end

  def edit
  end

  def update
    if @link.update(links_params)
      redirect_to root_path, notice: 'Link updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @link.destroy
    redirect_to root_path, notice: 'Link deleted successfully'
  end

  private

   def links_params
    params.require(:link).permit(:url, :title, :description, :views_count)
   end
end
