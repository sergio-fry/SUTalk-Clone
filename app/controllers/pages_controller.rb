class PagesController < ApplicationController
  before_filter :facebook_login, :except => :newfriends

  def home    
    if params[:sid].blank? && params[:request_ids].present?
      fb_request = @fb.getAppRequest(params[:request_ids].split(",").last)
      params[:sid] = ActiveSupport::JSON.decode(fb_request["data"])["sid"]
    end

    room = Room.getRoom request.remote_ip, params[:sid]
    @opentok_session = room
  end
  
  def newfriends      
    # @user = getUser fb

    # p "session[:facebook_id]"
    # p session[:facebook_id].inspect
 
    room = Room.getRoomNewFriends( request.remote_ip, params[:sid],     
                                   session[:facebook_id] )
    @opentok_session = room
      
    if request.xhr?
      render 'newfriends.js.erb', :layout => false
    end
  end
end

