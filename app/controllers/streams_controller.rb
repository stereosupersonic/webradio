class StreamsController < ApplicationController
  # Mix this module into your controller,
  # and all actions in that controller will be able to stream data to the client as it’s written.
  include ActionController::Live

  def show
    station = Station.find(params[:station_id])

    Rails.logger.info "### Station #{station.name}"
    uri = URI(station.url)
    Rails.logger.info "### URL: #{uri}"

    respond_to do |format|
      format.mp3 do
        stream(uri)
      end
    end
  end

  private

  def stream(uri)
    response.headers["Content-Type"] = "audio/mpeg"
    response.headers["Content-Disposition"] = "inline"
    # Stream die Daten direkt an den Client
    Net::HTTP.get_response(uri) do |remote_response|
      remote_response.read_body do |chunk|
        response.stream.write(chunk)
      end
    end
  rescue StandardError => e
    Rails.logger.error "Streaming failed: #{e.message}"
    response.stream.write("Streaming error")
  ensure
    response.stream.close
  end
end
