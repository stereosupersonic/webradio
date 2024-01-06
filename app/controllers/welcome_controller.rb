class WelcomeController < ApplicationController
  def index
    @stations = StationPresenter.wrap Station.order(:position)
  end
end
