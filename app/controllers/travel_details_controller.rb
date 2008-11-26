require 'department'
require 'travel_detail'
require 'hospitality_detail'

class TravelDetailsController < ScrapeableController
  
  def initialize
    super( 'TravelDetail', :travel_detail )
  end
  
  def confirm
    
      @model = get_model
      hospitality_report = @model.department.hospitality_details[0]
      hospitality_report.url = @model.department.get_random_hospitality_link
      hospitality_report.save!

      super()
  end

end
