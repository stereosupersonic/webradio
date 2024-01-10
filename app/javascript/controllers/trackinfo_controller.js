import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="trackinfo"
export default class extends Controller {
    static values = {
      src: String,
      interval: 10000
    }

    connect() {
      this.interval = setInterval(() => {
        this.element.reload()
      }, this.intervalValue)
    }

    disconnect() {
      clearInterval(this.interval)
    }
}
