class CurrentTrack
  include ActiveModel::Model

  attr_accessor :artist, :title, :response, :played_at, :source

  def to_s
    "#{artist} - #{title}"
  end

  def key
    to_s.parameterize
  end
end
