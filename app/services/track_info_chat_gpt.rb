# Usage:
#  TrackInfoChatGpt.new(artist: "The Beatles", title: "Yesterday").call
require "ruby/openai"
# require "JSON"

class TrackInfoChatGpt
  MODEL = "gpt-4o".freeze # OpenAI::Client.new.models.list

  attr_reader :artist, :title, :client, :model

  def initialize(artist:, title:)
    @artist = artist
    @title = title
    @model = ENV.fetch("CHAT_GPT_MODEL", MODEL)
    @client = OpenAI::Client.new
  end

  def call
    return if ENV["OPENAI_ACCESS_TOKEN"].blank? || artist.blank? || title.blank?

    # question = "What do you know about the song '#{title}' from '#{artist}?' can format the output to be more readable"

    question =
      "AS A MUSIC NERD " \
      "i need some informations about the song '#{title}' from the artist '#{artist}',  " \
      "such as Band info,  " \
      "release date,  " \
      "album title,   " \
      "background,  " \
      "the meaning of the lyrics  " \
      "and 3-4 lines of the lyrics " \
      "as bullet points.  " \
      "if you don't know the song, then write me that you don't know it!  " \
      "output format should be pure text." \

    Rails.logger.info "Aske ChatGPT: #{question}"

    response = client.chat(
      parameters: {
        # response_format: { type: "json_object" },
        model: model,
        messages:    [ { role: "user", content: question } ],
        temperature: 0.3
        # Die temperature bei einem ChatGPT-API-Call bestimmt, wie kreativ oder deterministisch die Antworten sind.
        # Niedrige Werte (z. B. 0.1 – 0.3) → Antworten sind präziser, vorhersehbarer und wiederholbar.
        # Hohe Werte (z. B. 0.7 – 1.5) → Antworten werden kreativer, zufälliger und abwechslungsre icher.
        # Falls du exakte und konsistente Antworten brauchst (z. B. für technische oder wissenschaftliche Anwendungen), solltest du die Temperatur ni edrig halten.
        # Wenn du kreativen Output möchtest (z. B. für Storytelling oder Brainstorming), kann eine höhere Temperatur  si nnvoll sein.
        # Ein typischer Standardwert ist 0.7 – ein guter Mix aus Kreativität und Konsistenz.
      }
    )

    Rails.logger.info "ChatGPT #{model} - response: #{response}"
    response.dig("choices", 0, "message", "content")
    # result = JSON.parse(json_response)
  end
end
