import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="refresh"
export default class extends Controller {
  static values = {
    src: String,
    interval: 10000 // 10 seconds
  }

  connect() {

    this.interval = setInterval(() => {
      if (this.element.src) {
        console.log('reloading...!!! '+ this.element.src)
        console.log('intervalValue: ', this.intervalValue)
        this.element.reload()
      } else {
        this.element.setAttribute('src', this.srcValue)
      }
    }, this.intervalValue)
  }

  disconnect() {
    clearInterval(this.interval)
  }
}
