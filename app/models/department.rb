
# add a patch to string to add a slugify method

class String
  def slugify
    self.downcase.gsub(/&/, ' and ').gsub(/[^a-z0-9']+/, '_').gsub(/^-|-$|'/, '')
  end
end

#
# Co-ordinates creating a scraper for a department.
#
# The order for creating a scraper is:
# - define department 
# - create link scrapers in order of depth
# - create scraper for travel reports
# - create scraper for hospitality reports
# - test reports
# - package scrapers and send them home
#

class Department < ActiveRecord::Base
  
  has_many :link_levels
  has_many :split_levels
  has_many  :travel_details
  has_many  :hospitality_details
  
  def path()
    return( "/departments/" + self.id.to_s())
  end
  
  # create a model for a particular level of our link tree.
  
  def make_tree_level( number, is_split )   
    if( number == 1)
      url = self.url
    else
      url = nil
    end
    name = "Level " + number.to_s
    if( is_split )
      SplitLevel.new( :department_id => self.id,
                     :level => number, :url => url, :completed => false, :name => name ).save!
    else
      LinkLevel.new( :department_id => self.id,
                    :level => number, :url => url, :completed => false, :name => name).save!
    end
  end
  
  # ensure our set of scrapeable models are created.
  
  def after_create()    
    return if( self.is_scrapeable != "Yes" )
    for i in (1..self.levels.to_i)
      make_tree_level( i, i == self.split_level )
    end
    
    TravelDetail.new( :department_id  => self.id,
                     :name => "Default Travel Report" ).save!
    
    HospitalityDetail.new( :department_id  => self.id,
                          :name => "Default Hospitality Report" ).save!
    
  end
  
  # Make sure that our link tree framework is consistent with the new data
  # saved.  Add/remove models as neccessary.
 
  def before_save
    
    # make sure our split level is in the right place.
    if( ! self.split_levels.empty? and self.split_levels[0].level != self.split_level.to_i )
      self.split_levels[0].destroy()
      make_tree_level( self.split_level.to_i, true )
    end  
    
    # add levels if we need to.
    if( self.levels.to_i > self.link_levels.size() )
      for i in (self.link_levels.size() + 1..self.levels.to_i)
        if( i != self.split_level.to_i )
          make_tree_level( i, false )
        end
      end
    end
    
    # delete levels if we need to
    if( self.levels.to_i < self.link_levels.size() )
      for i in (self.levels.to_i + 1 .. self.link_levels.size())
        LinkLevels.delete( :department_id => self.id,:level => i)
      end
    end
    
  end
  
  # remove all associated scrapeable objects.
  
  def after_destroy
    self.link_levels.collect() { |level| level.destroy() }
    SplitLevel.delete_all(:department_id => params[:id].to_i )
    HospitalityDetail.delete_all(:department_id => params[:id].to_i )
    TravelDetail.delete_all(:department_id => params[:id].to_i )  
  end
  
  # return a random link at the given depth.  Link may 
  # be either in the 'travel' category or 'hospitality' category.
  # Category info is only used if the specified level is deeper
  # than the split between link types.
  
  def get_random_link( to_level, travel_or_hospitality = "travel")
    bottom_link = nil
    
    # not every path reaches bottom.  Keep trying until we get one that does
    
    while( bottom_link == nil) do
        next_link = url
        for i in (1..to_level.to_i)
          level = get_level(i)
          if( i == self.split_level)
            next_link = level.get_links_of_type(next_link,travel_or_hospitality).sort_by{rand}.last          
          else
            next_link = level.get_random_link(next_link)
          end
          
          # break from the for loop if we hit a dead end 
          # start again from the top.
          
          break if (next_link == nil )
          puts travel_or_hospitality + ":" + i.to_s + "=" + next_link
        end
        bottom_link = next_link
      end
      return( bottom_link )
    end
    
    def get_random_hospitality_link
      get_random_link(self.levels.to_i,"hospitality")
    end
    
    
    def get_random_travel_link
      get_random_link(self.levels.to_i,"travel")
    end
    
    # mark that scraper generation for a given link in the tree 
    # is complete.  Allow the user to start the next level.
    
    def level_complete( level )
      
      # start the next level, if there is one.
      lower_level = level.level_down
            
      if( lower_level )
        example_link = level.get_links(level.url)[0]
        lower_level.url = example_link
        lower_level.save!
      else
        travel = travel_details[0]
        travel.url = example_link = get_random_travel_link
        travel.save!
      end
    end
    
    # return the link level template at the given numer.
    
    def get_level( level_no )
      if( level_no == self.split_level )
        return( SplitLevel.find( :first,
                                :conditions => { :department_id => self.id,
          :level => level_no  } ))
        
      else
        return( LinkLevel.find( :first,
                               :conditions => { :department_id => self.id,
          :level => level_no  } ))
        
      end
    end
    
    # return an in-order list of all the levels for this department.
    
    def get_levels
      levels = []
      for i in (1..self.levels.to_i)
        levels << self.get_level(i)
      end
      return( levels )
    end
    
    # returns true if department is scrapeable, and all scrapeable objects
    # have been completed.  Signals that department is ready for
    # testing and mailing.
    
    def scrapers_completed?
      return( false ) if (! self.scrapeable?)
      for scrapeable in get_scrapeables
        return ( false ) if( ! scrapeable.completed )
      end
      return( true )
    end
    
    def scrapeable?
      return( self.is_scrapeable == "Yes" )
    end
    
    # return the storage directory for all files related to this 
    # department.
    
    def data_dir
      Dir.mkdir('./data') unless File.directory?('./data')
      Dir.mkdir('./data/scrapers') unless File.directory?('./data/scrapers')
      dirname = "#{RAILS_ROOT}/data/scrapers/" + self.name.slugify()
      Dir.mkdir(dirname) unless File.directory?(dirname)
      return( dirname )
    end
    
    # return an array of all scrapeable objects associated with this
    # department.
    
    def get_scrapeables
      scrapeables = []
      for i in ( 1.. self.levels.to_i)
        scrapeables <<  self.get_level(i)
      end
      scrapeables << self.travel_details[0] if ( ! self.travel_details.empty? )
      scrapeables << self.hospitality_details[0] if ( ! self.hospitality_details.empty? )
      return( scrapeables )
    end
    
  end
