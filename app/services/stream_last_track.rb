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
    source = :unknown

    @fetched_data = read_stream.presence
    if @fetched_data.present?
      source = :stream
    else
      @fetched_data = read_json_stats.presence
      if @fetched_data.present?
        source = :json_stats
      end
    end

    return if @fetched_data.blank?

    response = extract_title_artist
    return if response.nil?

    current_track = CurrentTrack.new(
      artist: response.artist,
      title: response.title,
      response: @fetched_data,
      played_at: Time.current,
      source: source
    )

    if station.change_track_info_order?
      current_track.artist, current_track.title = current_track.title, current_track.artist
    end

    current_track
  end

  private

  def read_stream
    uri = URI.parse(station.url)

    Net::HTTP.start(uri.host, uri.port,
                    use_ssl: uri.scheme == "https",
                    read_timeout: 10,
                    open_timeout: 5) do |http|
      chunk_count = 0
      chunk_limit = 50
      buffer = ""

      http.get(uri.path, HEADERS) do |chunk|
        chunk_count += 1
        buffer += chunk

        # Try multiple patterns for different Shoutcast versions
        patterns = [
          /StreamTitle='([^']*?)';/m,
          /StreamTitle="([^"]*?)";/m,
          /icy-title:\s*(.+?)$/m
        ]

        patterns.each do |pattern|
          if buffer =~ pattern
            # Extract the track info from the buffer
            buffered_track = $1.force_encoding("UTF-8").scrub.strip
            Rails.logger.info "station: #{station.name} - Fetched track info: #{buffered_track.inspect} from stream"

            return buffered_track
          end
        end

        break if chunk_count > chunk_limit

        # Keep buffer manageable
        buffer = buffer.last(2048) if buffer.length > 4096
      end
    end

    nil
  rescue => e
    msg = "#{self.class.name}: stream #{station.name} - stream read failed: #{e.message}"
    # Rollbar.warning(msg, e)
    Rails.logger.warn msg
    nil
  end

  def read_json_stats
    uri = URI.parse(station.url)
    stats_uri = URI::HTTP.build(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: "/statistics",
      query: "json=1"
    )

    Net::HTTP.start(stats_uri.host, stats_uri.port,
                    use_ssl: stats_uri.scheme == "https",
                    read_timeout: 10,
                    open_timeout: 5) do |http|
      response = http.get(stats_uri.request_uri)

      if response.code == "200"
        data = JSON.parse(response.body)

        # Try different possible JSON fields for current track
        track_info = extract_track_from_json(data)

        track_info = track_info.split("by").reverse.join(" - ").strip if track_info.present? && track_info.include?("by")
        Rails.logger.info "station: #{station.name} - Fetched track info: #{track_info.inspect} from json_stat"
        return track_info.presence
      end
    end

    nil
  rescue JSON::ParserError => e
    msg = "#{self.class.name}: stream #{station.name} - JSON parse failed: #{e.message}"
    # Rollbar.warning(msg, e)
    Rails.logger.warn msg
    nil
  rescue => e
    msg = "#{self.class.name}: stream #{station.name} - JSON stats read failed: #{e.message}"
    # Rollbar.warning(msg, e)
    Rails.logger.warn msg
    nil
  end

  def extract_track_from_json(data)
    # Common JSON field names for current track in Shoutcast/Icecast
    possible_fields = [
      "songtitle",     # Shoutcast v2
      "title",         # Generic
      "song",          # Some implementations
      "current_song",  # Custom implementations
      "now_playing",   # Icecast
      "track",         # Generic
      "yp_currently_playing" # SHOUTcast DNAS
    ]

    # Handle nested JSON structures
    if data.is_a?(Hash)
      # Try direct fields first
      possible_fields.each do |field|
        value = data[field] || data[field.upcase] || data[field.downcase]
        return value.to_s.strip if value && !value.to_s.strip.empty?
      end

      # Try nested structures
      [ "streams", "stream", "data", "stats" ].each do |parent|
        if data[parent].is_a?(Hash)
          possible_fields.each do |field|
            value = data[parent][field]
            return value.to_s.strip if value && !value.to_s.strip.empty?
          end
        elsif data[parent].is_a?(Array) && data[parent].first.is_a?(Hash)
          # Handle array of streams
          possible_fields.each do |field|
            value = data[parent].first[field]
            return value.to_s.strip if value && !value.to_s.strip.empty?
          end
        end
      end
    end

    nil
  end
end
