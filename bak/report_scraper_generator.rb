
class ReportScraperGenerator < ScraperGenerator

  
  def initialize( name )
    super( "Report" + name )
  end  
  
  def create(args)
    file = File.open(learning_template_filename,'w')
    file.puts "require 'rubygems'" 
    file.puts "require 'scrubyt'"
    file.puts ""
    file.puts "class " + learning_template_classname 
    file.puts "  def scrape( url )"
    file.puts "    template = Scrubyt::Extractor.define do"
    file.puts "      fetch url"
    file.puts "      report do "
    file.puts "        person '" + args['person_name']  + ", " + args['person_position'] + "' do"
    file.puts "          person_name /^([^,]*),/"
    file.puts "          person_position  /,(.*)$/"
    file.puts "        end"
    file.puts "        expenses :generalize => true do"
    file.puts "          start_date '" + args['first_expense_start'] + "'"
    file.puts "          end_date '" + args['first_expense_end'] + "'"
    file.puts "          desc '" + args['first_expense_desc'] + "'"
    file.puts "          cost '" + args['first_expense_cost'] + "'"
    file.puts "        end.ensure_presence_of_pattern('cost').ensure_presence_of_pattern('desc')"
    file.puts "      end"
    file.puts "    end"
    file.puts "    template.export(__FILE__)"
    file.puts "    return( template )"
    file.puts "  end"
    file.puts "end"
    file.close  
  end
  
 end