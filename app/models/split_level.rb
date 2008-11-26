require 'generators/split_level_scraper_generator'
require 'scrapeable'
require 'department'

class SplitLevel < Scrapeable
  belongs_to :department
  
   def get_generator
     return(SplitLevelScraperGenerator.new( self.department))
   end
   
   def init_traits
    add_trait(:base_xpath , "Base XPath" )
    add_trait(:travel_div_xpath , "Travel Links Offset" )
    add_trait(:hospitality_div_xpath , "Hospitality Links Offset" )
  end

  def get_links(url)
    # default to travel links
    get_travel_links(url)
  end
  
   def path
     return("/departments/" + @attributes['department_id'].to_s() + "/split_levels/" + self.id.to_s() )
  end
 
  
  def get_links_of_type(url, travel_or_hospitality)
    generator = get_generator
    xml = generator.test_scraper(url)
    if( travel_or_hospitality == "travel")
      return( generator.get_link_array(xml,"//travel_expenses//expense/url"))
    else
      return( generator.get_link_array(xml,"//hospitality_expenses//expense/url"))
    end
  end
    
  def uses_template?
    return( false )
  end

   def level_down
      return( nil ) if (@attributes['level'] == self.department.levels )
      one_down = @attributes['level'].to_i + 1 
      return( self.department.get_level( one_down ) )    
   end
 

end
