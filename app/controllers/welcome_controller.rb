class WelcomeController < ApplicationController
  def index
    @stations = Station.order(:position)
  end
end
