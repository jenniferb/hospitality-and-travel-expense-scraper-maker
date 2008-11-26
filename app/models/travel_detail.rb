require 'generators/travel_detail_scraper_generator'
require 'scrapeable'
require 'department'

class TravelDetail < Scrapeable
  
  belongs_to :department
  
  def get_generator
    TravelDetailScraperGenerator.new( self.department)    
  end
  
  def path
      return("/departments/" + @attributes['department_id'].to_s() + "/travel_details/" + self.id.to_s() )
  end
  
  def get_test_link
    self.department.get_random_link(self.department.levels, "travel")
  end

  def init_traits
    add_trait( :report_xpath ,"Base XPath of Report")
    add_trait( :name_inside_table,"Name Inside Table?","checkbox")
    add_trait( :person_name_and_position_xpath ,"Offset XPath to Person Name/Position")
    add_trait( :person_name_format ,"Name Format","select",["Last, First, Position","First Last, Position","Last, First - Position"])
    add_trait( :date_format ,"Date Format","select",["One Cell", "Two Cells"])
    add_trait( :purpose ,  "Purpose Row #")
    add_trait( :start_date ,"Start Date Row #")
    add_trait( :end_date, "End Date Row (if two dates)")
    add_trait( :destinations , "Destination Row #")
    add_trait( :airfare , "Airfare Row #")
    add_trait( :other_travel , "Other Travel Row #")
    add_trait( :accomodation, "Accomodation Row #" )
    add_trait( :meals, "Meals Row #")
    add_trait( :other, "Other Row #")
    add_trait( :total, "Total Row #"  )
  end
  
  def test
    travel_link = self.department.get_random_travel_link()
    xml = self.get_generator.scrape(travel_link)
    return( xml )
  end
  
  def uses_template?
    return( false )
  end


end
