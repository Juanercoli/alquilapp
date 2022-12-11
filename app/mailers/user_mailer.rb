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
end