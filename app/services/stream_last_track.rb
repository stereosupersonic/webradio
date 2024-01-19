require "uri"
require "net/http"

HEADERS = {
  "Icy-MetaData" => "1"
}

class StreamLastTrack < LastTrackBase
  attr_reader :fetched_data
  attr_accessor :station

  def call
    return if station.nil?
    return if station.url.blank? || station.ignore_tracks_from_stream?

    @fetched_data = read_stream

    response = extract_title_artist

    return if response.nil?
    current_track = CurrentTrack.new artist: response.artist, title: response.title, response: @fetched_data, played_at: Time.current, source: :stream
    if station.change_track_info_order?
      current_track.artist = response.title
      current_track.title = response.artist
    end

    current_track
  end

  private

  def read_stream
    uri = URI.parse(station.url)
    http = Net::HTTP.new(uri.host, uri.port)

    chunk_count = 0
    chunk_limit = 20 # Limit chunks to prevent lockups
    begin
      http.get(uri.path, HEADERS) do |chunk|
        chunk_count += 1
        # Rails.logger.info "chunk: #{chunk} #{chunk_count}"
        if chunk =~ /StreamTitle='(.+?)';/
          return $1
        elsif chunk_count > chunk_limit
          return nil
        end
      end
    rescue => e
      msg = "stream #{station.name} - parse failed with message: #{e.message}"
      Rollbar.warning(msg, e)
      Rails.logger.error msg
    end

    # Just in case we get an HTTP error
    nil
  end
end
