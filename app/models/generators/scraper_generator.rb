require 'rubygems'
require 'scrubyt'
require 'page'

# Base class for handling scraper generation. 
# 
# Each scrapeable model references one class inheriting from a scraper
# generator. 
#
# Specifics of the Scrubyt scraper generated are contained in inheriting
# classes.

class ScraperGenerator
  
  attr_reader :name
  @department
  
  def initialize( department, name )
    @department = department
    @name = (department.name + name).gsub(/\s*/,"").gsub(/^-|-$|'/, '').gsub(/-/,'')   
  end
  
  # write the scrubyt extractor for a report subject's name and 
  # position following one of three common formats.  
  
  def person_name_and_position( file, args )
    name_xpath = args['person_name_and_position_xpath']
    if( args['name_inside_table'] == true )
      name_xpath += "/td[#{args['data_column']}]"
    end
    
    file.puts "           person_name_and_position \"" + name_xpath + "\" do "
    if( args['person_name_format'] == "Last, First, Position")
      file.puts "              last_name  /^\\s*([^,]+)\\s*,/"
      file.puts "              first_name /^\\s*[^,]+\\s*,([^,]+)\\s*,/"
      file.puts "              position /^\\s*[^,]+\\s*,[^,]+\\s*,(.*)/"
    end
    if( args['person_name_format'] == "First Last, Position")
      file.puts "last_name  /^[^,]+\\s+([^,]+),/"
      file.puts "first_name /^([^,]+)\\s+/"
      file.puts "position /,(.*)$/"
    end
    if( args['person_name_format'] == "Last, First - Position")
      file.puts "              last_name  /^\\s*([^,]+)\\s*,/"
      file.puts "              first_name /.*,\\s*([^,]+)\\s*-/"
      file.puts "              position /-(.*)\\s*$/"
    end
    file.puts "           end"
  end
  
  # write the scrubyt extractor for the dates in a report
  # following one of two options
  
  def dates( file, args )
    if( args['date_format'] == "One Cell")
      file.puts "              dates '/tr[" + args['start_date'] + "]/td[#{args["data_column"]}]' do"
      file.puts "                 start_date /^\\s*(\\S+)\\s*/"    
      file.puts "                 end_date /\\s*(\\S+)\\s*$/"    
      file.puts "              end"   
    else
      file.puts "                  start_date 'tr[" + args['start_date'] + "]/td[#{args["data_column"]}]' "
      file.puts "                  end_date 'tr[" + args['end_date'] + "]/td[#{args["data_column"]}]' "
    end
  end
  
  # has the template file been created?
  
  def template_created?
    File.exists?( learning_template_filename )
  end
  
  # has the scraper been created?
  
  def scraper_created?
    File.exists?( scraper_filename )
  end
  
  # test the learning template with the passed URL - return
  # the generated XML
  
  def test_template(url)
    require_dependency learning_template_filename  
    template = Object.const_get(learning_template_classname).new
    extractor = template.scrape(PageCache.new(url).file)
    xml = extractor.to_xml
    fix_links( url, xml )
    puts xml
    return( xml )
  end
  
  # test the scraper with the passed URL - return the generated
  # XML.
  
  def test_scraper(url)
    scraper = get_scraper
    xml = scraper.scrape(PageCache.new(url).file)
    fix_links(url,xml)
    return(xml)
  end
  
  # get an array of text from the XML
  
  def get_link_array( xml, xpath )
    links = []
    xml.elements.each(xpath) { |el|
      links << el.text
    }
    return( links )
  end
  
  # remove both the template file and generated scraper
 
  def cleanup
    File.delete( learning_template_filename ) if ( File.exists?( learning_template_filename ))
    File.delete( scraper_filename ) if ( File.exists?( scraper_filename ))
  end
  
  # remove the learning template file
  
  def cleanup_template
    File.delete( learning_template_filename ) if ( File.exists?( learning_template_filename ))   
  end
  
  def write_scraper( args )   
    file = File.open(scraper_filename,'w')
    file.puts "require 'rubygems'" 
    file.puts "require 'scrubyt'"
    file.puts 'require \'builder\''
    file.puts 'require \'rexml/document\''

    file.puts ""
    file.puts "class " + scraper_classname 
    file.puts "    def scrape( url )"    
    write_extractor( file, args )
    file.puts "   xml = template.to_xml"
    file.puts "    return( xml )"
    file.puts "  end"
    file.puts ""
    file.puts 'private'
    file.puts ""
    
    file.puts '    # The method below is an alternate way of scraping the same '
    file.puts '    # information, using hpricot directly.'

    write_hpricot_scraper(file, args)
    file.puts "end"
    file.close  
  end
  
  def write_template( args )   
    file = File.open(learning_template_filename,'w')
    file.puts "require 'rubygems'" 
    file.puts "require 'scrubyt'"
    file.puts ""
    file.puts "class " + learning_template_classname 
    file.puts "    def scrape( url )"    
    write_extractor( file, args )
    file.puts "    template.export( __FILE__ )"
    file.puts "    return( template )"
    file.puts "  end"
    file.puts ""
    file.puts "end"
    file.close  
  end
  
  def copy_scraper_from_template( args )
    arr = IO.readlines(production_template_filename)
    
    # get rid of the last line
    
    file = File.open( scraper_filename, 'w' )
    file.puts 'require \'rubygems\''
    file.puts 'require \'scrubyt\''
    file.puts 'require \'builder\''
    file.puts 'require \'rexml/document\''
    
    file.puts ''
    file.puts "class "+ scraper_classname     
    file.puts "def scrape( url )"     
    file.puts "   template = Scrubyt::Extractor.define do"     
    file.puts "   fetch url"     
    
    for i in (5..(arr.size - 2))
      file.puts arr[i]     
    end
    file.puts "    xml = template.to_xml"
    file.puts "    return (xml) "
    file.puts 'end'
    file.puts ''
    file.puts 'private'
    file.puts ''    
    file.puts '  # The method below is an alternate way of scraping the same '
    file.puts '  # information, using hpricot directly.'
    
    
    write_hpricot_scraper(file, args)
    
    file.puts 'end'
    file.close  
    
    cleanup_template()
  end
  
  
  def write_template_tester( url )
    file = File.open('./template_tester.rb', 'w' )
    file.puts "require 'rubygems'" 
    file.puts "require '" + learning_template_filename + "'"
    file.puts ""
    file.puts "template = " + learning_template_classname + ".new"
    file.puts "xml = template.scrape( '" + PageCache.new(url).file + "'  ).to_xml"
    file.puts "puts xml"
    file.close
  end
  
  def write_scraper_tester( url )
    file = File.open('./scraper_tester.rb', 'w' )
    file.puts "require 'rubygems'" 
    file.puts "require '" + scraper_filename + "'"
    file.puts ""
    file.puts "template = " + scraper_classname + ".new"
    file.puts "xml = template.scrape( '" + PageCache.new(url).file + "'  )"
    file.puts "puts xml"
    file.close
  end
  
  def learning_template_filename
    @department.data_dir() + '/' + learning_template_classname + '.rb'    
  end
  
  def scraper_filename
    @department.data_dir() + '/' + scraper_classname + '.rb'
  end
  
  def scraper_classname
    str = @name + 'Scraper'
    return(str)
  end
  
  private
  
  def get_scraper
    require_dependency scraper_filename
    scraper = Object.const_get( scraper_classname).new
    return( scraper )
  end
  
  
  def production_template_filename
    './template_extractor_export.rb'
  end
  
  
  def learning_template_classname 
    str =   @name + 'ScraperTemplate'
    return(str)
  end
  
  
  def fix_links( rooturl, xml )   
    uri = URI.parse( rooturl )
    http_path = "http://" + uri.host + Pathname(uri.path).dirname 
    xml.elements.each("//url")  { |element| 
      link = element.text
      
      if( link =~ /^\// )
        puts "link starts with /" + link
        element.text = "http://" + uri.host + link 
      else
        if( http_path =~ /\/$/ )
          puts "path ends with /" + http_path + " link " + link
          element.text = http_path + link
        else
          puts "adding / to " + http_path + " link " + link
          element.text = http_path + '/' + link        
        end
      end
       
    }     
  end
  
end