class LastTrackBase < BaseService
  protected

  def extract_title_artist
    return nil if fetched_data.blank?

    [ "-", ":" ].each do |splitter|
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
