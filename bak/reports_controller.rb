class ReportsController < ApplicationController
  def index
  end

  def show
     @report = Report.find(params[:id].to_i)
     @generator = @report.get_generator
     redirect_to edit_department_report_url(
                          :department_id => @report.department_id,
                          :id => @report.id ) if ( ! @report.is_filled_in ) 
  end

  def new
    @report = Report.new( :department_id => params[:department_id])
  end

  def create
    @report = Report.new( params[:report] )
    @report.department_id = params[:department_id]
    @report.completed = false
    @report.save!
    redirect_to department_url(params[:department_id])
  end

  def verify_template
    @report = Report.find(params[:report_id].to_i)
    if( ! @report )
      flash[:error] = "No such report"
      redirect_to department_url(params[:department_id])   
    end
    @xml = @report.check_template
    puts @xml
  end
  
  def verify_scraper
    @report = Report.find(params[:report_id].to_i)
    @report.write_scraper
    @xml = @report.scrape(@report.url)  
  end
  
  def confirm
    @report = Report.find(params[:report_id].to_i)
    @report.completed = true
  end

  def edit
    @report = Report.find(params[:id].to_i)
  end

  def update
    @report = Report.find(params[:id].to_i)
    @report.attributes = params[:report]
    @report.id = params[:id].to_i
    @report.save!
    flash[:notice] = "Report Updated"
    redirect_to department_report_url(:department_id => @report.department_id,
              :id => @report.id )

  end

  def destroy
  end

end
