require 'link_level'
require 'travel_detail'
require 'split_level'
require 'hospitality_detail'
require 'package'

class DepartmentsController < ApplicationController
  
  def show
    @department = Department.find(params[:id].to_i)
  end

   def update
    @department = Department.find(params[:id].to_i)
    
    @department.attributes = params['department']
    @department.save!
    flash[:notice] = "Updated"   
    redirect_to :action => 'show', :id => @department.id
  end

  def index
   @departments = Department.find(:all)
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(params[:department])
    @department.save!
    
                 
    flash[:notice] = 'Department Saved'
    redirect_to department_url(@department)
  end
  
  def edit
     @model = Department.find(params[:id].to_i)
  end
 
  def destroy
      Department.delete(params[:id].to_i)
      redirect_to departments_url()
  end
  
  def send_package
    @department = Department.find(params[:department_id].to_i)
    @package = Package.new(@department)   
  end
  
  def done
    @department = Department.find(params[:department_id].to_i)
    @department.completed = true
    @department.save()
    flash[:notice] = "Department #{@department.name} complete."   

    redirect_to departments_url()
  end

end
