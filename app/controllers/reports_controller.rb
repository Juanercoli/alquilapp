class ReportsController < ApplicationController
 
  def new
    @report = Report.new
  end
  
  def create
    @report = Report.new(report_params)
    @report.date = Time.now
    @report.user_id = Current.user.id
    @report.pending = true
    @report.car_id = Current.user.rentals.find_by(is_active:true).car.id
    @report.state = true
    if @report.save
      redirect_to car_tracking_path(Current.user.rentals.find_by(is_active:true).id), notice: 'Reporte enviado'
    else
      # Sino se renderiza de nuevo el formulario new
      # Se pasa como status unprocessable_entity para que TURBO entienda que el formulario no es correcto y se vuelva a renderizar (convención de turbo)
      render :new, status: :unprocessable_entity
    end
  end
  def index
    @reports = Report.all
  end
  
  def show
    report
  end
  
  def accept
    report
    report.state = true
    report.pending = false
    if(report.report_type == "Nafta")
      ##Acciones correspondientes al reporte de nafta
      report.user.wallet.balance += 3000 ## Se le suma 3000 al que reporto
      previous_wallet = CarUsageHistory.where(car_id:report.car.id).order("created_at").last.user.wallet
      previous_wallet.update_attribute(:balance, previous_wallet.balance - 3000) ## Se le resta 3000 al que se mando la makana
      report.user.wallet.save!

    elsif (report.report_type == "Accidente")
      ##Acciones correspondientes al reporte de un accidente
      @report.car.is_visible = false ##El auto se volvera invisible para los usuarios
      @report.car.save!
      UserMailer.with(user: report.user, message: 'ha habido un accidente con el auto los datos adjunto los datos los datos requeridos para solicitar el seguro: ', report_content: report.content).sent_car_insurance.deliver_later
    elsif (report.report_type == "Falla mécanica")
      ##acciones correspondientes al reporte de una falla mécanica
      @report.car.is_visible = false
      @report.car.save!

    end
    report.save!
    UserMailer.with(user: report.user, notify: 'su reporte fue aceptado, recibira soporte a la brevedad').accept_report.deliver_later
    redirect_to reports_path
  end
  
  def reject
    report
    report.pending = false
    report.state = false
    report.save!
    # Enviar mail de por qué rechaza el reporte
    UserMailer.with(user: report.user, motive: 'reporte rechazado').reject_report.deliver_later
    redirect_to reports_path
  end
  private

  def report
    @report ||= Report.find(params[:id])
  end

  def report_params
    # Se quiere que tenga un objeto Car antes que todo el contenido de parámetros
    # Luego se hace el permit con todo lo que debe tener
    params.require(:report).permit(:content, :report_type, :photo)
  end
  
end