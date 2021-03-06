class ApplicationController < ActionController::Base
  protect_from_forgery
  
  if Rails.env.production?
    rescue_from Exception, :with => :not_found
    rescue_from ActionController::RoutingError, :with => :not_found
  end

  layout 'application'
  
  def not_found
    render 'shared/not_found', layout: nil, status: 404
  end

  def denied
    # if(params[:anything] && params[:anything] =~ /\.ico$/)
    #   render nothing: true
    #   return
    # end
    render 'shared/denied', layout: nil, status: 401
  end
end
