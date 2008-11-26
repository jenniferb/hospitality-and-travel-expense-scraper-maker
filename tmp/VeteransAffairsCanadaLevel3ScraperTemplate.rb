require 'rubygems'
require 'scrubyt'

class VeteransAffairsCanadaLevel3ScraperTemplate
def scrape( rooturl )
    template = Scrubyt::Extractor.define do
        fetch rooturl
        level 'March 2 - June 1, 2008', :generalize => true do
            title /^.*$/
            url 'href', :type => :attribute
       end
    end
    template.export(__FILE__)
    return( template )
end
end
