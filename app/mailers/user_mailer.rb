class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome
    @user = params[:user]
    @name = @user.name.capitalize

    mail to: @user.email
  end

  def block
    @user = params[:user]
    @name = @user.name.capitalize

    mail to: @user.email
  end

  def unblock
    @user = params[:user]
    @name = @user.name.capitalize

    mail to: @user.email
  end

  def reject
    @user = params[:user]
    @name = @user.name.capitalize
    @motive = params[:motive].downcase
    @observations = params[:observations]

    mail to: @user.email
  end

  def reject_report
    @user = params[:user]
    @name = @user.name.capitalize
    @motive = params[:motive]
    @report_type = params[:report_type]

    mail to: @user.email
  end

  def fined
    @user = params[:user]
    @name = @user.name.capitalize
    @amount = params[:amount]
    @description = params[:description]
    
    mail to: @user.email
  end

  def accept
    @user = params[:user]
    @name = @user.name.capitalize
    @amount = params[:amount]

    mail to: @user.email
  end

  def accept_license
    @user = params[:user]
    @name = @user.name.capitalize

    mail to: @user.email
  end

  def reject_license
    @user = params[:user]
    @name = @user.name.capitalize

    mail to: @user.email
  end

  def accept_report
    @user = params[:user]
    @name = @user.name.capitalize
    @notify = params[:notify]
    @report_type = params[:report_type]

    if @report_type == "Nafta"
      @notify = "Se le cargaran $3000 a la billetera para cargar la nafta"
    end
    mail to: @user.email
  end

  def sent_car_insurance
    @user = params[:user]
    @name = @user.name.capitalize
    @surname = @user.surname.capitalize
    @dni = @user.dni
    @message = params[:message]
    @content = params[:report_content]

    mail to: "seguros@argentina.com"
  end
end