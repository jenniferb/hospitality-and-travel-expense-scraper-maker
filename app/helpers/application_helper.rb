# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def callout_header( title, id )
    return( "<div>
    <div class='callout_title'>#{title}</div>
    <div class='callout_close'><a href='#' onclick='$(\"#{id}\").slideToggle(250); return false;'>Close</a></div>
    </div>" )
  end
end
