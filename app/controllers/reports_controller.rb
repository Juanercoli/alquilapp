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
      redirect_to car_tracking_path(Current.user.rentals.find_by(is_active:true).id), notice: t('.sent')
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
      report.user.wallet.save!
      previous_user = CarUsageHistory.where(car_id:report.car.id).order("created_at").last.user
      previous_user.wallet.update_attribute(:balance, previous_user.wallet.balance - 3000) ## Se le resta 3000 al que se mando la makana
      @fine = Fine.create(user_id: previous_user.id, fine_price: 3000, fine_date: Time.now, description: 'no cargar la nafta')
      UserMailer.with(user: @fine.user,amount: @fine.fine_price ,description: @fine.description ).fined.deliver_later

    elsif (report.report_type == "Accidente")
      ##Acciones correspondientes al reporte de un accidente
      @report.car.is_visible = false ##El auto se volvera invisible para los usuarios
      @report.car.save!
      UserMailer.with(user: report.user, message: 'Ha habido un accidente con un auto de la empresa, le adjunto datos del conductor', report_content: report.content).sent_car_insurance.deliver_later
    elsif (report.report_type == "Falla mécanica")
      ##acciones correspondientes al reporte de una falla mécanica
      @report.car.is_visible = false
      @report.car.save!

    end
    report.save!
    UserMailer.with(user: report.user, report_type: report.report_type, notify: 'Recibira soporte a la brevedad').accept_report.deliver_later
    redirect_to reports_path
  end
  
  def reject
    report
    report.pending = false
    report.state = false
    report.save!
    # Enviar mail de por qué rechaza el reporte
    UserMailer.with(user: report.user, report_type: report.report_type, motive: 'el contenido del reporte es invalido').reject_report.deliver_later
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