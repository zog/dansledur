class MediaController < ApplicationController
  before_filter :fetch_medium, except: [:index, :new, :create, :fetch, :hall_of_fame]
  before_filter :authenticate!, only: [:update, :edit, :new, :create, :destroy]
  def index
    @medias = Medium
    @search = params[:search]
    @medias = @medias.tagged_with(@search.split(',')) unless @search.nil?
    @medias = @medias.order(:'created_at DESC'  ).paginate(:page => params[:page], :per_page => 9)
    @suggestions = []
    @suggestions = Medium.suggestions_for(@search) if @search && @medias.count.zero?
  end
  
  def hall_of_fame
    @medias = Medium.order(:'views_count DESC'  ).paginate(:page => params[:page], :per_page => 9)
  end
  
  def show
    @medium.touch!
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
  
  def delete
    if @medium
      @medium.destroy
      redirect_to(media_path, notice: "Media destroyed, Feel my Power ! MWAHAHAHAHA") && return
    end
    redirect_to media_path
  end
  
protected
  def authenticate!
    denied unless current_user    
  end

  def fetch_medium
    @medium = Medium.find(params[:id]) rescue not_found
  end
end
