class ApplicationController < ActionController::Base
  protect_from_forgery
  
  unless  ActionController::Base.consider_all_requests_local
    rescue_from Exception, :with => :not_found
  end


  layout 'application'
  
  def not_found
    render 'shared/not_found', layout: nil, status: 404
  end

  def denied
    render 'shared/denied', layout: nil, status: 401
  end
end
