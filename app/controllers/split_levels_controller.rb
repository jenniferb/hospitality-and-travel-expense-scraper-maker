require 'travel_detail'

class SplitLevelsController  < ScrapeableController
  
  def initialize
    super( 'SplitLevel', :split_level )
  end

   def confirm   
    link_level = get_model
    link_level.department.level_complete( link_level ) 
    super()
   end

end
