require "rspotify"

# https://developer.spotify.com/dashboard
class SpotifyAddToPlaylist
  attr_reader :spotify_track
  def initialize(spotify_track:)
    @spotify_track = spotify_track
  end

  def call
    if auth
     playlist = RSpotify::Playlist.find('stereosonic', '4hCzjwNBI1KkP8Mz6UucTi')
     playlist.add_tracks!([spotify_track]) if playlist && @spotify_track
    else
      Rails.logger.error "Spotify authentication failed"
      nil
    end
  end

end
