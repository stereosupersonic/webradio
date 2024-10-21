class StationPresenter < ApplicationPresenter
  def station_logo
    o.logo_url
  end

  def radio_box_url
    "https://onlineradiobox.com/#{o.radiobox}/playlist/"
  end

  def browser_info_url
    "https://www.radio-browser.info/history/#{o.browser_info_byuuid}"
  end
end
