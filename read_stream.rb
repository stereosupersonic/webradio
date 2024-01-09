
require 'uri'
require 'net/http'

URL = "http://listen.181fm.com/181-eagle_128k.mp3"

HEADERS = {
  "Icy-MetaData" => '1'
}

def parse_shoutcast_stream
  @last_update = Time.now
  uri = URI.parse(URL)
  http = Net::HTTP.new(uri.host, uri.port)

  chunk_count = 0
  chunk_limit = 20 # Limit chunks to prevent lockups
  begin
    http.get(uri.path, HEADERS) do |chunk|
      chunk_count += 1
      if chunk =~ /StreamTitle='(.+?)';/
        return $1
        break;
      elsif chunk_count > chunk_limit
        return nil
      end
    end
  rescue Exception => e
    puts "Shoucast stream parse failed with message:\n"
    puts e.message
  end

  # Just in case we get an HTTP error
  return nil
end

puts parse_shoutcast_stream
