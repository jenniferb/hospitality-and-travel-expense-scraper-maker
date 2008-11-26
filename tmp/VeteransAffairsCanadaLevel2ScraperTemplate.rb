require 'rubygems'
require 'scrubyt'

class VeteransAffairsCanadaLevel2ScraperTemplate
def scrape( rooturl )
    template = Scrubyt::Extractor.define do
        fetch rooturl
        level 'Thompson, Greg, Minister', :generalize => true do
            title /^.*$/
            url 'href', :type => :attribute
       end
    end
    template.export(__FILE__)
    return( template )
end
end
