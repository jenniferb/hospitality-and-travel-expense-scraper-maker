require 'page'

class Report < ActiveRecord::Base
  belongs_to :department
  
  def is_filled_in
     return( @attributes['first_expense_cost'] && @attributes['first_expense_cost'] != "" )  
  end
  
  def get_generator
    return( ReportScraperGenerator.new(@attributes['report_name']))
  end
  
  def check_template      
      generator = get_generator
      generator.create(@attributes)
      file = PageCache.new(self.url).file
      puts file
      xml = generator.test_template(file)
      return(xml)
  end

 
  def write_scraper
      generator = get_generator
      generator.write
  end
   
  def scrape( url )
      generator = get_generator
      scraper = generator.get_scraper
      return( scraper.scrape(url) )
  end
  
end
