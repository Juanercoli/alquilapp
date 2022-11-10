class MainController < ApplicationController
  skip_before_action :protect_pages, only: [:index] # Solo se skipea la protección para index

  def index
  end
end