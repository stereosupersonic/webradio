require "nokogiri"
require "open-uri"

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
    return if station.radio_box_url.blank?
    @url = station.radio_box_url

    value = Array(doc.css(SELECTOR))[0]
    @fetched_data = value&.text

    if fetched_data.blank?
      Rails.logger.error "#{self.class.name}: no track for selector '#{SELECTOR}' url: #{@url}"
      return
    end

    response = extract_title_artist

    return if response.nil?

    current_track = CurrentTrack.new artist: response.artist, title: response.title, response: value.to_html, played_at: Time.current, source: :radiobox

    if station.change_track_info_order?
      current_track.artist = response.title
      current_track.title = response.artist
    end

    current_track
  end

  private

  def fetch_html
    # better way to do this is to use a proxy

    URI.open @url # rewrite this
  end

  def doc
    @doc ||= ::Nokogiri::HTML(fetch_html)
  end
end
