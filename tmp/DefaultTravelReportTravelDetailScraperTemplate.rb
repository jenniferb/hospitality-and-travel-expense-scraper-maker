require 'rubygems'
require 'scrubyt'

class DefaultTravelReportTravelDetailScraperTemplate
  def scrape( url )
    template = Scrubyt::Extractor.define do
      fetch url
        report :generalize => true do 
           start_date '2008-02-19 to 2008-02-21'
           purpose 'To attend the Taxpayers\' Ombudsman announcement'
           destinations 'Winnipeg, MB'
           airfare '$2,125.59'
           meals '$150.40'
           accomodation '$490.56'
           other_travel '$0.00'
           total '$2,786.55'
      end
    end
    template.export(__FILE__)
    return( template )
  end
end
