class MediaController < ApplicationController
  before_filter :fetch_medium, except: [:index, :new, :create, :fetch]
  
  def index
    @medias = Medium
    @search = params[:search]
    @medias = @medias.tagged_with(@search.split(' '), any: true) if @search
    @medias = @medias.order(:'created_at DESC'  ).paginate(:page => params[:page], :per_page => params[:page].to_i > 1 ? 7 : 8)
  end
  
  def show
  end
  
  def update
    @medium.update_attributes params[:medium]
    redirect_to medium_path(@medium)
  end
  
  def fetch
    render text: Medium.fetch_from_twitter.to_i
  end
  
  def new
    @medium = Medium.new
  end
  
  def create
    @medium = Medium.create! params[:medium]
    redirect_to media_path
  rescue
    @medium = Medium.new
    render template: 'media/new'
  end
  
  def edit
  end
  
  def destroy
    if @medium
      @medium.destroy
      redirect_to(media_path, notice: "Media destroyed, Feel my Power ! MWAHAHAHAHA") && return
    end
    redirect_to media_path
  end
  
protected
  def fetch_medium
    @medium = Medium.find(params[:id])
  end
end
