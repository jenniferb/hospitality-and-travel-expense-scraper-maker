require 'rubygems'
require 'scrubyt'

class VeteransAffairsCanadaLevel1ScraperTemplate
def scrape( rooturl )
    template = Scrubyt::Extractor.define do
        fetch rooturl
        level 'Minister, Assistant to Minister and their exempt staff', :generalize => true do
            title /^.*$/
            url 'href', :type => :attribute
       end
    end
    template.export(__FILE__)
    return( template )
end
end
