require "page"

# A trait of a scrapeable objects.  Used to define generic forms and 
# display pages for each object.

class Trait
    attr_reader :trait_name
    attr_reader :label
    attr_reader :type
    attr_reader :options

    def initialize( name, label, type = 'textfield', options = nil )
      @trait_name = name
      @label = label
      @type = type
      @options = options
   end

end

# Base class for all scrapeable objects.  
# 
# Inheritors define:
#  - database fields to store template parameters
#  - scraper generator class for creating scrapers.

class Scrapeable < ActiveRecord::Base
   self.abstract_class = true
   
  @traits = []

  def add_trait( name, label, type = 'textfield', option = nil)
      @traits << Trait.new(name,label,type,option)
  end
  
  # return all traits defined for this object
    
  def get_traits
    if( (@traits == nil) || (@traits.size == 0) )
      @traits = []
      init_traits
    end
    return( @traits )
  end

  # when the previous scrapeably object in a sequence is completed, it 
  # writes the URL of the next object in the sequence.
  #
  # Whether or not the URL of the scrapeable object is filled in is used
  # to indicate that the user can start working on that object.
  
  def is_started?
      return( @attributes['url'] != nil )
  end
  
  # returns true if the model uses the 'learning template' mode of 
  # scrubyt
  
  def uses_template?
    return( true )
  end
  
  # return the local page cache file for this object.
  
  def page_cache()
    return( "file:///" + Dir.pwd + "/" + PageCache.new(@attributes['url']).file )
  end

  # has the user already filled this model with data?
 
  def filled_in?
    traits = get_traits
    traits.each { | trait |
          return( false ) if( (@attributes[ trait.trait_name ] == nil) or (@attributes[ trait.trait_name ] == "") )
    }
    return( true )
  end

  # return the http path for this REST object -- used because Rails
  # polymorphic_url helper would sometimes blow the stack.
  
  def path
     return("/departments/" + @attributes['department_id'].to_s() + "/" + self.table_name() + "s/" + self.id.to_s() )
  end
  
  def init_traits
   #override me 
  end

  def get_generator
    #override me
  end
end
