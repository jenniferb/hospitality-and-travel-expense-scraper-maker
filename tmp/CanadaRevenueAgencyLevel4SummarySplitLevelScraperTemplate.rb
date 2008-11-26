require 'rubygems'
require 'scrubyt'

class CanadaRevenueAgencyLevel4SummarySplitLevelScraperTemplate
  def scrape( url )
    template = Scrubyt::Extractor.define do
      fetch url
        travel_header 'Travel expenses - December 2, 2007 - March 1, 2008', :generalize => true
        travel_expenses :generalize => true do 
          desc 'To visit the Tax Service Office. Trip was cancelled.', :generalize => true do
              title /^.*$/
              url  'href', :type => :attribute
        end
        end
        hosp_header 'Hospitality expenses - December 2, 2007 - March 1, 2008', :generalize => true
        hospitality_expenses  :generalize => true do
           desc 'Refreshments (coffee, milk, water) for meetings and events', :generalize => true do
              title /^.*$/
              url  'href', :type => :attribute
          end
        end
    end
    template.export(__FILE__)
    return( template )
  end
end
