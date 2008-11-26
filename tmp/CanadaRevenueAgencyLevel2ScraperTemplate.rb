require 'rubygems'
require 'scrubyt'

class CanadaRevenueAgencyLevel2ScraperTemplate
def scrape( rooturl )
    template = Scrubyt::Extractor.define do
        fetch rooturl
        level 'Babcock, Brent, Director of Parliamentary Affairs', :generalize => true do
            title /^.*$/
            url 'href', :type => :attribute
       end
    end
    template.export(__FILE__)
    return( template )
end
end
