class HomeController < ApplicationController
  def index
  	@sl_active = "active"
		@posts = Post.find(:all, :order => "updated_at DESC")
  end

  def news
   	@sl_active = "active"
   	
  end
end
