class WelcomeController < ApplicationController
  def index
    @stations = StationPresenter.wrap(Station.ordered)
  end
end
