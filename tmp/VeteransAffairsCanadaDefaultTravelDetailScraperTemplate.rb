require 'rubygems'
require 'scrubyt'

class VeteransAffairsCanadaDefaultTravelDetailScraperTemplate
  def scrape( url )
    template = Scrubyt::Extractor.define do
      fetch url
      report do 
        detail :generalize => true do 
           start_date '2008-04-11'
           end_date '2008-04-14'
           purpose 'Regional announcements and Commendation ceremonies'
           destinations 'Ottawa - Fredericton - St. Stephen - Ottawa'
           airfare '$5,729.10'
           purpose 'Regional announcements and Commendation ceremonies'
           meals '$0.00'
           accomodation '$0.00'
           other_travel ' $0.00'
           total '$5,729.10'
      end
    end
    end
    template.export(__FILE__)
    return( template )
  end
end
