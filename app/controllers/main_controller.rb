class MainController < ApplicationController
  def index
      @hide_header_links = true
  end

  def comingsoon
    
  end
  
  def introduction
    @introduction = Lesson.unscoped.find_by_category("0")
  end
  
end
