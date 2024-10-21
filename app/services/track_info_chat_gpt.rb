# Usage:
#  TrackInfoChatGpt.new(artist: "The Beatles", title: "Yesterday").call
require "ruby/openai"
# require "JSON"

class TrackInfoChatGpt
  attr_reader :artist, :title, :client

  def initialize(artist:, title:)
    @artist = artist
    @title = title

    @client = OpenAI::Client.new
  end

  def call
    return if ENV["OPENAI_ACCESS_TOKEN"].blank? || artist.blank? || title.blank?

    # question = "What do you know about the song '#{title}' from '#{artist}?' can format the output to be more readable"

    question =
     "AS A MUSIC NERD " \
     "i need some informations about the song '#{title}' from the artist '#{artist}', " \
    " such as Band info, "\
    " release date, " \
    " highest chart Position, " \
    " Recording Studio " \
    " album title,  " \
    " background, " \
    " the meaning of the lyrics " \
    " and 3-4 lines of the lyrics" \
    " as bullet points. "

    Rails.logger.info "Aske ChatGPT: #{question}"
    response = client.chat(
      parameters: {
        # response_format: { type: "json_object" },
        # model: "gpt-3.5-turbo-1106",
        model: "gpt-3.5-turbo",
        messages: [ { role: "user", content: question } ],
        temperature: 0.7 # what does temperature do?

      }
    )

    Rails.logger.info "ChatGPT response: #{response}"
    response.dig("choices", 0, "message", "content")
    # result = JSON.parse(json_response)
  end
end
