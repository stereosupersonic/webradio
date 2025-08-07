require "nokogiri"
require "open-uri"
require "net/http"
# url = https://onlineradiobox.com/uk/absolute1058/playlist/
# script .playlist tr.active a
# radio_box = Radiobox.new url: "https://onlineradiobox.com/uk/absolute1058/playlist/", script: ".playlist tr.active a"

# http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=03a888a88c3abea4963563b3f736862c&artist=cher&track=believe&format=json

class RadioboxLastTrack < LastTrackBase
  SELECTOR = ".playlist .tablelist-schedule tr:first td[2]".freeze
  Response = Struct.new(:artist, :title, :response, :played_at, :key)

  attr_accessor :station

  attr_reader :fetched_data, :url

  def call
    return if station.nil?
    return if station.radiobox.blank?

    @url = station.radio_box_url

    value = Array(doc.css(SELECTOR))[0]
    @fetched_data = value&.text

    if fetched_data.blank?
      Rails.logger.error "#{self.class.name}: no track for selector '#{SELECTOR}' url: #{@url}"
      return
    else
      Rails.logger.info "station: #{station.name} - Fetched track info: #{fetched_data.inspect} from radiobox"
    end

    response = extract_title_artist

    return if response.nil?

    CurrentTrack.new artist: response.artist, title: response.title, response: value.to_html, played_at: Time.current, source: :radiobox
  end

  private

  def fetch_html_new
    parsed_url = URI.parse(@url)

    begin
      response = Net::HTTP.get_response(parsed_url)

      if response.is_a?(Net::HTTPSuccess)
        # Process the content as needed for a successful response
        return response.body
      elsif response.code.to_i == 404
        msg = "#{self.class.name}: 404 Not Found: The requested resource was not found - url: #{@url} station: #{station}"
        # You can choose to handle 404 errors in a specific way here
      else
        msg = "#{self.class.name}: #{response.code} - #{response.message} - #{@url} station: #{station}"
        # Handle other errors as needed
      end
    rescue => e
      msg = "#{self.class.name}: Error: #{e.message} - #{@url} station: #{station}"
    end
    Rollbar.warning msg
    Rails.logger.error msg
    nil
  end

  def fetch_html
    # better way to do this is to use a proxy

    URI.open @url # rewrite this
  rescue OpenURI::HTTPError => e
    if e.message == "404 Not Found"
      msg = "#{self.class.name}: 404 Not Found for url: #{@url} station: #{station.name}"
      Rollbar.warning msg
      Rails.logger.error msg
      return nil
    end
    raise e
  end

  def doc
    @doc ||= ::Nokogiri::HTML(fetch_html)
  end
end
