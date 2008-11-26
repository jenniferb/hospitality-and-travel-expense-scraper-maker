require 'page'

#
# Base class controller for all scrapeable objects
#

class ScrapeableController < ApplicationController
  
  @model_class
  @symbol_name
  
  # model_class: Upper Case class name, eg. ScrapeableController
  # symbol_name: lower case symbol name for class, eg. :scrapeable_controller
   
   def initialize( model_class, symbol_name )
     super()
     @model_class = model_class
     @symbol_name = symbol_name
   end

  # return the model belonging to this controller

  def get_model
    Object.const_get(@model_class).find(get_id_param(params))  
  end
  
  def get_id_param( params )
    return( params[ :id ] ) if params[ :id ]
    return( params[ @symbol_name.to_s + '_id' ])    
  end
  
  def show
    @model = get_model
  end

 def edit
    @model = get_model
    @model.page_cache()
  end

  
   def update
    @model = get_model
    
    @model.get_traits.each { | trait |
       if params[@symbol_name][trait.trait_name.to_s] and params[@symbol_name][trait.trait_name.to_s] =~ /tbody/
        params[@symbol_name][trait.trait_name.to_s] = params[@symbol_name][trait.trait_name.to_s].gsub(/\/tbody/,"")
       end
    }

    @model.attributes = params[@symbol_name]
 
    @model.save!
    @model.get_generator.cleanup
    flash[:notice] = "Updated"   
    redirect_to :action => 'show', :id => @model.id, :department_id => @model.department_id
  end

  # create the learning template for this model
  
  def create_template
    @model = get_model
    generator = @model.get_generator
    generator.write_template( @model.attributes ) 
    generator.write_template_tester( @model.url )
  end
  
  # verify the learning template for this model
      
   def verify_template
    @model = get_model
    generator = @model.get_generator
    @xml = generator.test_template( @model.url )
  end

  # create the scraper for this model.
  
  def create_scraper
    @model = get_model
    generator = @model.get_generator
    
    # does the model use a scrubyt template?  If so, copy the scraper
    # from the template.  Otherwise, write it directly.
    
    if( @model.uses_template? )
      generator.copy_scraper_from_template( @model.attributes )
    else
      generator.write_scraper( @model.attributes )
    end
    generator.write_scraper_tester(@model.url)
  end
  
  # verify the scraper for this model
  
  def verify_scraper
    @model = get_model
    generator = @model.get_generator
     @xml = generator.test_scraper( @model.url )
  end
  
  # test this model using a randomly generated link.
  
  def test
    @model = get_model
    @test_link = @model.get_test_link()
    @xml = @model.get_generator.test_scraper( @test_link )
  end
  
  # confirm this model is complete.
  
  def confirm
    @model = get_model
    @model.completed = true
    @model.save!
    redirect_to @model.department
  end

end