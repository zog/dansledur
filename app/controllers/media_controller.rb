class MediaController < ApplicationController
  def index
    @medias = Medium
    @search = params[:search]
    @medias = @medias.tagged_with(@search.split(' '), any: true) if @search
    @medias = @medias.order(:created_at).all
  end
  
  def new
    @media = Medium.new
  end
  
  def create
    @media = Medium.create! params[:medium]
    redirect_to media_path
  end
end
