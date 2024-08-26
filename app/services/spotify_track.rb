require "rspotify"

class SpotifyTrack
  attr_reader :artist, :title
  def initialize(artist:, title:)
    @artist = artist
    @title = title
  end

  def call
    return nil if artist.blank? || title.blank? || ENV["SPOTIFY_CLIENT_ID"].blank? || ENV["SPOTIFY_CLIENT_SECRET"].blank?
    if auth
      RSpotify::Track.search("#{artist} - #{title}").first
    else
      Rails.logger.error "Spotify authentication failed"
      nil
    end
  end

  private

  def auth
    RSpotify.authenticate(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"])
    true
  rescue => e
    Rails.logger.error "Spotify authentication error: #{e.message}"
    false
  end
end
