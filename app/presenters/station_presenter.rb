class StationPresenter < ApplicationPresenter
  def station_logo
    o.logo_url.blank? ? "default_station.jpeg" : o.logo_url
  end
end
