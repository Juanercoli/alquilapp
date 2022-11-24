class CarsUsageHistoriesController < ApplicationController
  def show
    @history = CarUsageHistory.where(car_id: params[:id])
  end
end