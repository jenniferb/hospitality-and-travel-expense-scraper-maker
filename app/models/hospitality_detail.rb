require 'generators/hospitality_detail_scraper_generator'
require 'scrapeable'
require 'department'

class HospitalityDetail < Scrapeable

  belongs_to :department
  
  def get_generator
    HospitalityDetailScraperGenerator.new( self.department)    
  end

  def path
     return("/departments/" + @attributes['department_id'].to_s() + "/hospitality_details/" + self.id.to_s() )
  end

  def uses_template?
    return( false )
  end

  def init_traits
    add_trait( :report_xpath ,"Base XPath of Report")
    add_trait( :name_inside_table,"Name Inside Table?","checkbox")
    add_trait( :person_name_and_position_xpath ,"Offset XPath to Person Name/Position")
    add_trait( :person_name_format ,"Name Format","select",["Last, First, Position","First Last, Position","Last, First - Position"])
    add_trait( :date_format ,"Date Format","select",["One Cell", "Two Cells"])
    add_trait( :purpose ,  "Purpose Row")
    add_trait( :start_date ,"Start Date Row (eg 1,2...)")
    add_trait( :end_date, "End Date Row (if two dates)")
    add_trait( :location , "Location Row")
    add_trait( :attendees , "Attendees Row")
    add_trait( :total, "Total Row"  )
    add_trait( :data_column, "Data Column #"  )
  end
  
  def get_test_link
    self.department.get_random_link(self.department.levels, "hospitality")
  end

end
