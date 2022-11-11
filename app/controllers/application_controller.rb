class ApplicationController < ActionController::Base
  around_action :switch_locale # Por cada petición HTTP se llama a este método
  before_action :set_current_user # Antes de cualquier acción
  before_action :protect_pages # Protege todas las páginas, debo indicar en cada controller si quiero skipear esta acción

  def switch_locale(&action)
    # Se cambia el idioma para la petición en concreto
    I18n.with_locale(locale_from_header, &action)
  end

  private

  def locale_from_header
    # El idioma se puede leer en la cabecera de cada petición
    request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
  end

  def set_current_user
    # Busca al usuario por id y si no lo encuentra no lanza excepción
    # Atributo disponible a toda la aplicación
    # Solo se realiza si existe una sesión
    # Lo almacena como usuario actual
    if session[:user_role] == "client"
      Current.user = User.find_by(id: session[:user_id]) if session[:user_id] 
      Current.role = Current.user.role? if session[:user_role] 
    else
      Current.user = SuperUser.find_by(id: session[:user_id]) if session[:user_id] 
      Current.role = Current.user.role? if session[:user_role] 
    end
  end

  def protect_pages
    # Si no se estableció un usuario entonces redirigir a pagina princiapl
    redirect_to main_index_path, alert: t('common.not_logged_in') unless Current.user
  end
end
