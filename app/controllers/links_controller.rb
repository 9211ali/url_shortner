class LinksController < ApplicationController

  before_action :set_link, only: [ :show, :edit, :update, :destroy ]
  before_action :check_if_editable, only: [ :edit, :update, :destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_path, notice: "Couldn't find the link to the application"
  end

  def index
    @pagy, @links = pagy(Link.recent_first)
    @link ||= Link.new
    rescue Pagy::OverflowError
      params[:page] = 1
      retry
  end

  def create
    @link = Link.new(links_params.merge(user_id: current_user&.id))
    if @link.save
      respond_to do |format|
        format.html { redirect_to root_path }
        # format.turbo_stream { render turbo_stream: [turbo_stream.prepend('links', @link), turbo_stream.replace("link_form", partial: 'links/form', locals: { link: Link.new })] }
        format.turbo_stream { render turbo_stream: turbo_stream.prepend('links', @link) }
      end
    else
      render :index, status: :unprocessable_entity
    end
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

   def check_if_editable
     unless @link.editable_by?(current_user)
       redirect_to @link, alert: 'You are not allowed to edit'
     end
   end
end
