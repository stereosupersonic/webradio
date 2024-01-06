require "timeout"

#require 'lastfm'

class VlcPlayer
  def initialize(url)
    @backend = "vlc -I rc"
    @url = url
  end

  def play
    @io = IO.popen("#{@backend} \"#{@url}\"", "r+")
  end

  def info
    io_command("info")
  end

  def now_playing
    result = info
    now_playing_line = result.lines.find { |l| l.include?("now_playing:") }
    if now_playing_line
      now_playing_line.split("now_playing:").last.chomp.strip
    end
  rescue
    nil
  end

  def lastfm_info
    puts "lastfm_info for #{now_playing}"
    return unless now_playing

    @lastfm ||= Lastfm.new("3879f14f3720aeee9ff3e585f9778004", "5399970a5a169ed73cd39e9af5042c70")
    # @token  ||= @lastfm.auth.get_token
    # puts "token: #{@token}"
    @token = "BwSdyS6lN9hxdnKrFK-oabxfKFABnuhh"
    @session_token ||= @lastfm.auth.get_session(token: @token)['key']

    # open 'http://www.last.fm/api/auth/?api_key=3879f14f3720aeee9ff3e585f9778004&token=BwSdyS6lN9hxdnKrFK-oabxfKFABnuhh' and grant the application

    @lastfm.session = @session_token

    @lastfm.track.search(now_playing)

    search_result = @lastfm.track.search(track: song.to_search_term,
    limit: limit)['results']['trackmatches']['track'].compact
    found_songs = []

    search_result.each do |r|
      found_songs << @lastfm.track.get_info(track: r['name'],
                                            artist: r['artist'])
    end

    found_songs
  end

  def debug
    @io.puts("info")
    @io.gets
  end

  private

  def io_command(command)
    @io.puts(command)
    io_all_gets
  end

  def io_all_gets
    result = ""
    while (gets_result = io_gets)
      result += gets_result.to_s
    end
    result
  end

  def io_gets
    Timeout.timeout(0.01) do
      @io.gets
    end
  rescue => e
    puts e
  end
end

# player = VlcPlayer.new("http://edge-bauerall-01-gos2.sharp-stream.com/absoluteradio.mp3")
# player.play
