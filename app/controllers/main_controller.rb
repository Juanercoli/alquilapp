class MainController < ApplicationController

  def index
    @cars = Car.all.to_json
  end
  
end