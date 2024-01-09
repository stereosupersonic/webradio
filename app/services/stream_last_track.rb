require "uri"
require "net/http"

HEADERS = {
  "Icy-MetaData" => "1"
}
class StreamLastTrack < BaseService
  Response = Struct.new(:artist, :title, :response, :played_at)

  attr_reader :fetched_data
  attr_accessor :url

  def call
    @fetched_data = read_stream
    Rails.logger.debug "fetched_data: #{@fetched_data}"

    response = extract_title_artist

    return if response.nil?

    Response.new(response.artist, response.title, @fetched_data, Time.current)
  end

  private

  def read_stream
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    chunk_count = 0
    chunk_limit = 20 # Limit chunks to prevent lockups
    begin
      http.get(uri.path, HEADERS) do |chunk|
        chunk_count += 1
        if chunk =~ /StreamTitle='(.+?)';/
          return $1
          break
        elsif chunk_count > chunk_limit
          return nil
        end
      end
    rescue => e
      Rails.logger.error "stream #{url} parse failed with message: #{e.message}"
    end

    # Just in case we get an HTTP error
    nil
  end

  def extract_title_artist
    return nil if fetched_data.blank?

    ["-", ":"].each do |splitter|
      artist, title = *fetched_data.split(" #{splitter} ")
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
