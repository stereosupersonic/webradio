# Usage:
#  TrackInfoChatGpt.new(artist: "The Beatles", title: "Yesterday").call

require "ruby/openai"

class TrackInfoChatGpt
  attr_reader :artist, :title, :client

  def initialize(artist:, title:)
    @artist = artist
    @title = title

    @client = OpenAI::Client.new
  end

  def call
    return if ENV["OPENAI_ACCESS_TOKEN"].blank? || artist.blank? || title.blank?
  
    question = "What do you know about the song #{title} from #{artist}? can format the output to be more readable"

    # question = "Can you send me the lyric from song #{title} by #{artist}?"
    Rails.logger.info "Aske ChatGPT: #{question}"
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{role: "user", content: question}],
        temperature: 0.7
      }
    )
    Rails.logger.info "ChatGPT response: #{response}"

    response.dig("choices", 0, "message", "content")
  end
end
