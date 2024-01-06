require "net/http"
require "json"

class BrowserInfoUpdater < BaseService
  attr_accessor :station

  def call
    return if station&.browser_info_byuuid.blank?
    Rails.logger.info "Updating station #{station.name} from browser info"

    url = URI.parse("http://91.132.145.114/json/stations/byuuid/#{station.browser_info_byuuid}")
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body, object_class: OpenStruct)[0]
      # Now 'data' contains the parsed JSON data.
      station.url = data.url_resolved
      station.name = data.name
      station.logo_url = data.favicon if station.logo_url.blank?
      station.homepage = data.homepage
      station.save!
      Rails.logger.info "Updated station #{station.name} from browser info"
    else
      puts "Failed to fetch data: #{response.message}"
    end
  end
end
