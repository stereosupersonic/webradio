require "nokogiri"
require "open-uri"

# url = https://onlineradiobox.com/uk/absolute1058/playlist/
# script .playlist tr.active a
# radio_box = Radiobox.new url: "https://onlineradiobox.com/uk/absolute1058/playlist/", script: ".playlist tr.active a"

# http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=03a888a88c3abea4963563b3f736862c&artist=cher&track=believe&format=json

class RadioboxLastTrack < BaseService
  SELECTOR = ".playlist .tablelist-schedule tr:first td[2]".freeze
  Response = Struct.new(:artist, :title, :response, :played_at, :key)

  attr_reader :fetched_data
  attr_accessor :url

  def call
    return if @url.blank?

    value = Array(doc.css(SELECTOR))[0]
    @fetched_data = value&.text

    if fetched_data.blank?
      Rails.logger.error "no track for selector '#{SELECTOR}' url: #{@url}"
      return
    end

    Rails.logger.info "fetched_data: #{fetched_data}"

    response = extract_title_artist

    return if response.nil?

    played_at = Time.current # TODO: use the real date
    key = "#{response.artist}-#{response.title}".parameterize
    Response.new(response.artist, response.title, value.to_html, played_at, key)
  end

  private

  def fetch_html
    # better way to do this is to use a proxy

    URI.open @url # rewrite this
  end

  def doc
    @doc ||= ::Nokogiri::HTML(fetch_html)
  end

  def extract_title_artist
    [" - ", " : ", ": ", "- "].each do |splitter|
      artist, title = *fetched_data.split(splitter.to_s)
      artist = normalize(artist)
      title = normalize(title)
      if valid_value?(title) && valid_value?(artist)
        return OpenStruct.new(artist: artist, title: title)
      end
    end
    nil
  end

  def valid_value?(value)
    value.presence.to_s =~ /[a-zA-Z0-9]/
  end

  def normalize(text)
    TrackSanitizer.new(text: text).call
  end
end
