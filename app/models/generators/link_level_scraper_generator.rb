require "generators/scraper_generator"

class LinkLevelScraperGenerator < ScraperGenerator

  
  def initialize( department, name )
      super( department, name )
   end
   
  def write_extractor( file, args )
    file.puts "    template = Scrubyt::Extractor.define do"
    file.puts "        fetch url"
    file.puts "        level '#{args['example_text']}', :generalize => true do"
    file.puts "            title /^.*$/"
    file.puts "            url 'href', :type => :attribute"
    file.puts "        end"
    file.puts "    end"
  end
  
  def write_hpricot_scraper(file, args)
    file.puts ""
    file.puts "   def scrape_w_hpricot( url )"
    file.puts "     doc = Hpricot(open(url))"
    file.puts "     builder = Builder::XmlMarkup.new( :indent => 2 )"
    file.puts "     links = doc.search('** XPATH TO LINK**')"
    file.puts "     xml = builder.levels do"
    file.puts "       links.each { |link|"
    file.puts "         builder.level { |b| "
    file.puts "           b.title(link.inner_html);"
    file.puts "           b.url(link.attributes['href']) "
    file.puts "        }"
    file.puts "       }"
    file.puts "    end" 
    file.puts "    return( REXML::Document.new(xml) )"
    file.puts "   end"
    file.puts ""
  end
  
 end