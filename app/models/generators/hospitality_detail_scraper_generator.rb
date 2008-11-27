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
       file.puts "           expense '/table' do"
       person_name_and_position(file,args)
    else
        person_name_and_position(file,args)
        file.puts "           expense '/table' do"
    end
    dates(file,args)
    file.puts "              purpose '/tr[" + args["purpose"] + "]/td[#{args["data_column"]}]'"
    file.puts "              location '/tr[" + args["location"] + "]/td[#{args["data_column"]}]'"
    file.puts "              attendees '/tr[" + args["attendees"] + "]/td[#{args["data_column"]}]'"
    file.puts "              total '/tr[" + args["total"] + "]/td[#{args["data_column"]}]'"
    file.puts "          end"
    file.puts "        end"
    file.puts "    end"
  end
  
  def write_hpricot_scraper(file, args)
    file.puts ""
    file.puts "   # This is provided for example only -- offsets, etc. may not be correct"
    file.puts ""
    file.puts "   def scrape_w_hpricot( url )"
    file.puts "      doc = Hpricot(open(url))"
    file.puts "      builder = Builder::XmlMarkup.new( :indent => 2 )"
    file.puts "      table = doc.search('#{args['report_xpath']}')"
    file.puts "      person_name_and_position = table.search('#{args['person_name_and_position']}').inner_html"
    file.puts "      dates_string = table.search('/tr[#{args["start_date"]}]/td[#{args["data_column"]}]').inner_html"
    file.puts ""       
    file.puts "      xml = builder.report do"
    file.puts "        builder.expense do"
    file.puts "          builder.purpose( table.search('/tr[#{args["purpose"]}]/td[#{args["data_column"]}]').inner_html)"
    file.puts "          dates_string =~ /^\s*(\S+)\s*/"
    file.puts "          builder.start_date(Regexp.last_match[1])"
    file.puts "          dates_string =~ /\s*(\S+)\s*^/"
    file.puts "          builder.end_date( Regexp.last_match[1] )"
    file.puts "          person_name_and_position =~/^\s*([^,]+)\s*,\s*([^,]+)\s*,\s*(.*)/"
    file.puts " "
    file.puts "          builder.last_name(Regexp.last_match[1] )"
    file.puts "          builder.first_name(Regexp.last_match[2] )"
    file.puts "          builder.position(Regexp.last_match[3] ) "
    file.puts "          builder.location(table.search('/tr[#{args["location"]}]/td[#{args["data_column"]}]').inner_html)"
    file.puts "          builder.attendees(table.search('/tr[#{args["attendees"]}]/td[#{args["data_column"]}]').inner_html)"
    file.puts "          builder.total(table.search('/tr[#{args["total"]}]/td[#{args["data_column"]}]').inner_html)"
    file.puts "        end                 "
    file.puts "     end"
    file.puts "  end"

  end

  
  
 end