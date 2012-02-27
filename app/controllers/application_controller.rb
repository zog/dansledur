class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout 'application'
  
  def not_found
    render 'shared/not_found', layout: nil, status: 404
  end

  def denied
    render 'shared/denied', layout: nil, status: 401
  end
end
