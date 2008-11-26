require 'rubygems'
require 'scrubyt'

class CanadaRevenueAgencyLevel1ScraperTemplate
def scrape( rooturl )
    template = Scrubyt::Extractor.define do
        fetch rooturl
        level 'View reports - Minister, Parliamentary Secretary, and exempt staff', :generalize => true do
            title /^.*$/
            url 'href', :type => :attribute
       end
    end
    template.export(__FILE__)
    return( template )
end
end
