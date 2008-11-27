require "generators/scraper_generator"

class SplitLevelScraperGenerator < ScraperGenerator
  
  def initialize( department )
    super( department, "SplitLevel"   )
  end  
  
  def write_extractor( file, args )
    file.puts "    template = Scrubyt::Extractor.define do"
    file.puts "      fetch url"
    file.puts "      report '" + args['base_xpath'] + "' do"
    file.puts "        travel_expenses '" + args['travel_div_xpath'] + "' do" 
    file.puts "              expense '//a' do"
    file.puts "                title /^.*$/"
    file.puts "                url  'href', :type => :attribute "
    file.puts "              end"
    file.puts "            end"
    file.puts "        hospitality_expenses '" + args['hospitality_div_xpath'] + "'  do" 
    file.puts "              expense '//a' do"
    file.puts "                title /^.*$/"
    file.puts "                url  'href', :type => :attribute "
    file.puts "              end"
    file.puts "         end"
    file.puts "     end"
    file.puts "     end"
  end
  
  def write_hpricot_scraper(file, args)
    file.puts "     def scrape_w_hpricot( url )"
    file.puts "     doc = Hpricot(open(url))"
    file.puts "     builder = Builder::XmlMarkup.new( :indent => 2 )"
    file.puts "     travel_links = doc.search('**XPATH TO TRAVEL LINKS (base + offset)**')"
    file.puts "     hospitality_links = doc.search('**XPATH TO HOSPITALITY LINKS (base + offset) ')"
    file.puts ""
    file.puts "     xml = builder.report do"
    file.puts "       builder.travel_expenses do"
    file.puts "          travel_links.each { |link|"
    file.puts "            builder.expense { |b| "
    file.puts "              b.title(link.inner_html);"
    file.puts "              b.url(link.attributes['href']) "
    file.puts "          }"
    file.puts "        }"
    file.puts "       end"
    file.puts "       builder.hospitality_expenses do"
    file.puts "          hospitality_links.each { |link|"
    file.puts "            builder.expense { |b| "
    file.puts "              b.title(link.inner_html)"
    file.puts "              b.url(link.attributes['href']) "
    file.puts "          }"
    file.puts "        }"
    file.puts "       end             "    
    file.puts "    end"
    file.puts "    return( REXML::Document.new(xml) )"
    file.puts "   end"
    file.puts ""
    
  end
  
  
end
