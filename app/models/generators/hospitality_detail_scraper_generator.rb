require "generators/scraper_generator"

class HospitalityDetailScraperGenerator < ScraperGenerator

  
  def initialize( department )
    super( department, "HospitalityDetail"  )
  end    
    
  def write_extractor( file, args )
    file.puts "    template = Scrubyt::Extractor.define do"
    file.puts "      fetch url"
    file.puts "        report '" + args['report_xpath'] + "'  do "
     if( args['name_inside_table'] == true )
       file.puts "           expense '//table' do"
       person_name_and_position(file,args)
    else
        person_name_and_position(file,args)
        file.puts "           expense '//table' do"
    end
    dates(file,args)
    file.puts "              purpose '/tr[" + args["purpose"] + "]/td[2]'"
    file.puts "              location '/tr[" + args["location"] + "]/td[2]'"
    file.puts "              attendees '/tr[" + args["attendees"] + "]/td[2]'"
    file.puts "              total '/tr[" + args["total"] + "]/td[2]'"
    file.puts "          end"
    file.puts "        end"
    file.puts "    end"
  end
  
  def write_hpricot_scraper(file, args)
  end

  
  
 end