require "rspotify"

class SpotifyTrack
  attr_reader :artist, :title
  def initialize(artist:, title:)
    @artist = artist
    @title = title
  end

  def call
    return nil if artist.blank? || title.blank? || ENV["SPOTIFY_CLIENT_ID"].blank? || ENV["SPOTIFY_CLIENT_SECRET"].blank?
    auth
    RSpotify::Track.search("#{artist} - #{title}").first
  end

  private

  def auth
    RSpotify.authenticate(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"])
  end
end
