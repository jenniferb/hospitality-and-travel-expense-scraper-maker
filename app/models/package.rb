require 'zip/zip'
require 'zip/zipfilesystem'

# Creates a package of scrapers for sending to VisibleGovernment.ca

class Package
  
   @department
   
   def initialize( department )
      @department = department
      write_dept_file()
      make_zip()
   end

   def create()
     write_dept_file() 
    end
 
  def name
    return( @department.data_dir() + "/" + @department.name.slugify() + ".zip" )
  end

private

   def write_dept_file()
     f = File.open(department_filename, 'w') 
     f.puts @department.to_yaml
     
     f.puts ""
     f.puts @department.get_scrapeables.to_yaml
     f.puts ""
     f.close
  end
 
  def make_zip()
   
   filename = name()
   File.delete(filename) if File.file?(filename)
     
   Zip::ZipFile.open(filename, Zip::ZipFile::CREATE) { |zipfile|
      @department.get_scrapeables().collect() { |scrapeable|
         puts scrapeable.get_generator.scraper_classname
         zipfile.add( @department.name.slugify + "/" + scrapeable.get_generator.scraper_classname() +".rb", scrapeable.get_generator.scraper_filename)
       }      
       zipfile.add( @department.name.slugify + '/department.yml', department_filename)
   }

 
   File.chmod(0644, filename)

   end
    
  def department_filename
    return( @department.data_dir() + '/department.yml' )
  end
  
end