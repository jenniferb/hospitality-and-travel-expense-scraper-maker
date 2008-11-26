require "department"

class LinkLevelsController < ScrapeableController
  
   def initialize
    super( 'LinkLevel', :link_level )
  end

  def confirm 
  
    link_level = get_model
    link_level.department.level_complete( link_level ) 
    super()
    
   end

end
