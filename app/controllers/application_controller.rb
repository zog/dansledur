class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout 'application'
  
  def not_found
    render 'shared/not_found', layout: nil
  end
end
