class TrackInfosController < ApplicationController
  def index
    artist = params[:artist]
    title = params[:title]
    @current_track_key = params[:key]
    Rails.logger.info "artist: #{artist} -title: #{title}"

    @chat_gpt_said = if artist.present? && title.present?
      cache_key = "v1/current_track_chat_gpt/#{@current_track_key}".parameterize
      Rails.cache.fetch(cache_key) do
        TrackInfoChatGpt.new(artist: artist, title: title).call
      end
    end
  end
end
