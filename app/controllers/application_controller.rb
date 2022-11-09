class ApplicationController < ActionController::Base
  around_action :switch_locale # Por cada petición HTTP se llama a este método

  def switch_locale(&action)
    # Se cambia el idioma para la petición en concreto
    I18n.with_locale(locale_from_header, &action)
  end

  private

  def locale_from_header
    # El idioma se puede leer en la cabecera de cada petición
    request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
  end
end
