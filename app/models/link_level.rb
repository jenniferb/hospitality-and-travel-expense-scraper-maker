require 'generators/link_level_scraper_generator'
require 'scrapeable'

class LinkLevel < Scrapeable
  
  belongs_to :department
        
  def init_traits
    add_trait(:example_text , "Example Link Text or XPath" )
  end
 
  def get_generator
     LinkLevelScraperGenerator.new( self.department, "Level" + @attributes['level'] )
  end
        
  def level_up
    return( nil ) if( @level == '1')
    one_up = @level.to_i - 1 
    return( self.department.get_level( one_up ) )    
  end

   def level_down
      return( nil ) if (@attributes['level'] == self.department.levels )
      one_down = @attributes['level'].to_i + 1 
      return( self.department.get_level( one_down ) )    
   end
   
   def get_random_link( url )
      links = get_links(url)
      return( links.sort_by{rand}.last )
   end
   
   def path()
     #return(self.department.path() + "/link_levels/" + self.id.to_s() )
     return("/departments/" + @attributes['department_id'].to_s() + "/link_levels/" + self.id.to_s() )
   end
       
   def get_links( url )
     generator = get_generator
     xml = generator.test_scraper(url)
     return( generator.get_link_array(xml,"//url"))
   end
  
end
