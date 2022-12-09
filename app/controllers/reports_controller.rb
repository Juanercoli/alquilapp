class ReportsController < ApplicationController
 
  def new
    @report = Report.new
    ##De alguna manera se consigue el id del auto
    ##@rental = Rental.find_by(id:params[:id])
    ##@car_id = @rental.car_id
  end
  
  def create
    @report = Report.new(report_params)
    @report.date = Time.now
    @report.user_id = Current.user.id
  end
  
  def index
    @reports = Report.all
  end
  
  def show
    
  end
  
  def accept
  
  end
  
  def reject
  end
  private

  def report
    @report ||= Report.find(params[:id])
  end

  def report_params
    # Se quiere que tenga un objeto Car antes que todo el contenido de parámetros
    # Luego se hace el permit con todo lo que debe tener
    params.require(:report).permit(:content, :report_type)
  end
  
end