require 'rubygems'
require 'scrubyt'

class VeteransAffairsCanadaDefaultSummaryReportSummaryScraperTemplate
  def scrape( url )
    template = Scrubyt::Extractor.define do
      fetch url
      report do 
        person 'Thompson, Greg, Minister' do
          person_name /^(.*),/
          person_position  /,([^,]+)$/
        end
        summary_start 'March 2'
        summary_end 'June 1, 2008'
        travel_expenses :generalize => true do 
          desc 'Regional announcements and Commendation ceremonies', :generalize => true do
              title /^.*$/
              url  'href', :type => :attribute
        end
        end
        hospitality_expenses  :generalize => true do
           desc 'Dinner meeting to discuss Veterans Affairs issues', :generalize => true do
              title /^.*$/
              url  'href', :type => :attribute
          end
        end
      end
    end
    template.export(__FILE__)
    return( template )
  end
end
