require 'hpricot'


# Represents an HTML page in the database.  Links 
# a URL with a page downloaded to a local data cache.

class Page < ActiveRecord::Base
end

# Access to the PageCache
# - use a database entry to link an URL with a page in our 
#   data cache.

class PageCache

  @url
  @id
  
  def initialize( url )
      @url = url
      page = Page.find_by_url( url ) 
      if( page )
        @id = page.id
      else
        page = Page.new( :url => url )
        page.save!
        @id = Page.find_by_url( url ).id
        
        # get rid of any stale data in the cache
        # -- we may have cleared our database
        
        File.delete(filename) if( File.exists?(filename))
      end
    
    Dir.mkdir('./data') unless File.directory?('./data')
    Dir.mkdir('./data/cache') unless File.directory?('./data/cache')
  end

  # return the cached file.  If it doesn't exist, create it by
  # downloading it from the internet.
  
  def file
    name =  filename
    if( ! File.exist?(name) )
        cmd = 'curl --user-agent "Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.5) Gecko/20070713 FireFox/2.0.0.5" --compressed "' + @url + '" > ' + name+".tmp"
        puts cmd
        system(cmd)

        doc = open(name + ".tmp") { |f| Hpricot f, :fixup_tags => true }
        f = File.open(name, 'w')
        f.puts doc
        f.close
    end
    return( name )
  end
  
  private
  
  def filename
    return(   './data/cache/page' + @id.to_s  + '.html' )    
  end
  
end
